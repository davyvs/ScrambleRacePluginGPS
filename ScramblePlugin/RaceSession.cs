using System.Numerics;
using AssettoServer.Network.Tcp;
using AssettoServer.Server;
using AssettoServer.Shared.Network.Packets.Outgoing;
using AssettoServer.Shared.Network.Packets.Shared;
using ScramblePlugin.Packets;
using Serilog;

namespace ScramblePlugin;

/// <summary>Represents the lifecycle phase of a race session.</summary>
public enum RacePhase
{
    /// <summary>Waiting for at least one player to /accept.</summary>
    AcceptWindow,

    /// <summary>At least one player has accepted; countdown running before race starts.</summary>
    Countdown,

    /// <summary>Race is live — tracking positions and collisions.</summary>
    Racing,

    /// <summary>All participants have finished or been disqualified.</summary>
    Finished
}

/// <summary>
/// Manages the full lifecycle of a single scramble race:
/// accept window → countdown → racing → finish/DQ for all participants.
/// One instance exists per active starting area.
/// </summary>
public class RaceSession
{
    /// <summary>Name of the starting area this race was initiated from.</summary>
    public string StartAreaName { get; }

    /// <summary>Destination configuration for this race.</summary>
    public DestinationConfig Destination { get; }

    /// <summary>Current race lifecycle phase.</summary>
    public RacePhase Phase { get; private set; } = RacePhase.AcceptWindow;

    /// <summary>All participants, keyed by SessionId. Includes the initiator.</summary>
    public Dictionary<byte, ACTcpClient> Participants { get; } = new();

    /// <summary>SessionIds of participants who have been disqualified.</summary>
    public HashSet<byte> DisqualifiedIds { get; } = new();

    /// <summary>SessionIds of participants who have successfully arrived.</summary>
    public HashSet<byte> ArrivedIds { get; } = new();

    private readonly ScrambleConfiguration _config;
    private readonly EntryCarManager _entryCarManager;
    private readonly Action<RaceSession> _onSessionEnd;

    private long _countdownEndsAt;

    /// <summary>Returns true while the countdown is running and others can still /accept.</summary>
    public bool IsAcceptWindowOpen =>
        Phase == RacePhase.Countdown
        && Environment.TickCount64 < _countdownEndsAt;

    /// <summary>
    /// Initialises a new race session initiated by <paramref name="initiator"/>.
    /// The countdown starts immediately — the initiator sees the GPS right away,
    /// and other players have <see cref="ScrambleConfiguration.TimeToAcceptSeconds"/> to /accept.
    /// </summary>
    public RaceSession(
        string startAreaName,
        DestinationConfig destination,
        ACTcpClient initiator,
        ScrambleConfiguration config,
        EntryCarManager entryCarManager,
        Action<RaceSession> onSessionEnd)
    {
        StartAreaName = startAreaName;
        Destination = destination;
        _config = config;
        _entryCarManager = entryCarManager;
        _onSessionEnd = onSessionEnd;

        Participants[initiator.SessionId] = initiator;

        // Start countdown immediately — initiator sees GPS straight away
        Phase = RacePhase.Countdown;
        _countdownEndsAt = Environment.TickCount64 + config.TimeToAcceptSeconds * 1000L;

        long raceStartsAt = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds()
                             + config.TimeToAcceptSeconds * 1000L;
        initiator.SendPacket(new ScrambleRaceStateEvent
        {
            RaceState = RaceState.Countdown,
            DestName = destination.Name,
            DestX = destination.Coordinates[0],
            DestY = destination.Coordinates[1],
            DestZ = destination.Coordinates[2],
            DestRadius = destination.Radius,
            RaceStartsAt = raceStartsAt
        });
    }

    /// <summary>
    /// Called when a player types /accept. Joins them into the running countdown.
    /// </summary>
    public void AddParticipant(ACTcpClient client)
    {
        if (Phase != RacePhase.Countdown) return;

        Participants[client.SessionId] = client;
        Log.Information("ScramblePlugin: {Player} joined race from {Area} to {Dest}",
            client.Name, StartAreaName, Destination.Name);

        // Send current countdown state to the late joiner
        long remaining = Math.Max(0, _countdownEndsAt - Environment.TickCount64);
        long raceStartsAt = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds() + remaining;
        client.SendPacket(new ScrambleRaceStateEvent
        {
            RaceState = RaceState.Countdown,
            DestName = Destination.Name,
            DestX = Destination.Coordinates[0],
            DestY = Destination.Coordinates[1],
            DestZ = Destination.Coordinates[2],
            DestRadius = Destination.Radius,
            RaceStartsAt = raceStartsAt
        });
    }

    /// <summary>
    /// Called from the service tick loop (~250 ms interval).
    /// Advances the session through Countdown → Racing state machine.
    /// </summary>
    public void Tick(EntryCarRaceState[] carStates)
    {
        if (Phase == RacePhase.Countdown)
            TickCountdown(carStates);
    }

    private void TickCountdown(EntryCarRaceState[] carStates)
    {
        if (Environment.TickCount64 < _countdownEndsAt) return;

        Phase = RacePhase.Racing;
        Log.Information("ScramblePlugin: Race from {Area} to {Dest} started with {Count} participants",
            StartAreaName, Destination.Name, Participants.Count);

        // Check speed at start — DQ any participant who is moving
        var toDisqualify = new List<byte>();
        foreach (var (sessionId, client) in Participants)
        {
            if (DisqualifiedIds.Contains(sessionId)) continue;
            var car = client.EntryCar;
            if (car.Status.Velocity.Length() > _config.MaxStartSpeedMs)
            {
                toDisqualify.Add(sessionId);
            }
        }

        foreach (var sessionId in toDisqualify)
            DisqualifyParticipant(sessionId, Packets.DqReason.MovingAtStart, carStates);

        // Send Racing state to remaining participants
        foreach (var (sessionId, client) in Participants)
        {
            if (DisqualifiedIds.Contains(sessionId)) continue;
            client.SendPacket(new ScrambleRaceStateEvent
            {
                RaceState = RaceState.Racing,
                DestName = Destination.Name,
                DestX = Destination.Coordinates[0],
                DestY = Destination.Coordinates[1],
                DestZ = Destination.Coordinates[2],
                DestRadius = Destination.Radius,
                RaceStartsAt = 0
            });
            carStates[sessionId].ResetForRace();
        }

        int activeCount = Participants.Count - DisqualifiedIds.Count;
        _entryCarManager.BroadcastPacket(new ChatMessage
        {
            SessionId = 255,
            Message = $"\xF0\x9F\x8F\x81 {activeCount} player{(activeCount == 1 ? "" : "s")} started a race from {StartAreaName} to {Destination.Name}!"
        });

        CheckSessionComplete();
    }

    /// <summary>
    /// Records a participant arrival. Broadcasts the result and clears that player's HUD.
    /// </summary>
    public void RecordArrival(byte sessionId, EntryCarRaceState[] carStates)
    {
        if (Phase != RacePhase.Racing) return;
        if (ArrivedIds.Contains(sessionId) || DisqualifiedIds.Contains(sessionId)) return;
        if (!Participants.TryGetValue(sessionId, out var client)) return;

        ArrivedIds.Add(sessionId);
        int position = ArrivedIds.Count;
        string name = client.Name ?? $"Car {sessionId}";

        Log.Information("ScramblePlugin: {Player} arrived at {Dest} in position {Pos}",
            name, Destination.Name, position);

        _entryCarManager.BroadcastPacket(new ChatMessage
        {
            SessionId = 255,
            Message = $"\xF0\x9F\x8F\x81 {name} arrived at {Destination.Name} in position {position}!"
        });

        client.SendPacket(new ScrambleResultEvent
        {
            Status = ResultStatus.Finished,
            Position = (byte)Math.Min(position, 255),
            DqReason = Packets.DqReason.None
        });

        client.SendPacket(new ScrambleRaceStateEvent { RaceState = RaceState.Idle });
        carStates[sessionId].ClearRace();

        CheckSessionComplete();
    }

    /// <summary>
    /// Disqualifies a participant with the given reason, notifying them and all other participants.
    /// </summary>
    public void DisqualifyParticipant(byte sessionId, byte reason, EntryCarRaceState[] carStates)
    {
        if (DisqualifiedIds.Contains(sessionId)) return;
        if (!Participants.TryGetValue(sessionId, out var client)) return;

        DisqualifiedIds.Add(sessionId);
        string name = client.Name ?? $"Car {sessionId}";
        string reasonText = reason switch
        {
            Packets.DqReason.Teleport => "teleport",
            Packets.DqReason.MovingAtStart => "moving at race start",
            Packets.DqReason.TooManyCollisions => "too many collisions",
            Packets.DqReason.Disconnected => "disconnected",
            _ => "unknown reason"
        };

        Log.Information("ScramblePlugin: {Player} disqualified from race — {Reason}", name, reasonText);

        client.SendPacket(new ScrambleResultEvent
        {
            Status = ResultStatus.Disqualified,
            Position = 0,
            DqReason = reason
        });

        client.SendPacket(new ScrambleRaceStateEvent { RaceState = RaceState.Idle });
        carStates[sessionId].ClearRace();

        // Notify other participants
        SendToAllParticipants(new ChatMessage
        {
            SessionId = 255,
            Message = $"\xE2\x9D\x8C {name} has been disqualified ({reasonText})."
        }, excludeSessionId: sessionId);

        CheckSessionComplete();
    }

    private void SendToAllParticipants<T>(T packet, byte? excludeSessionId = null)
        where T : IOutgoingNetworkPacket
    {
        foreach (var (sessionId, client) in Participants)
        {
            if (excludeSessionId.HasValue && sessionId == excludeSessionId.Value) continue;
            if (DisqualifiedIds.Contains(sessionId)) continue;
            client.SendPacket(packet);
        }
    }

    private void CheckSessionComplete()
    {
        int remaining = Participants.Count - ArrivedIds.Count - DisqualifiedIds.Count;
        if (remaining <= 0)
        {
            EndSession();
        }
    }

    private void EndSession()
    {
        Phase = RacePhase.Finished;
        Log.Information("ScramblePlugin: Race from {Area} to {Dest} ended", StartAreaName, Destination.Name);
        _onSessionEnd(this);
    }
}
