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
    /// <summary>Accept window open — waiting for players to /accept in the start area.</summary>
    AcceptWindow,

    /// <summary>Race is live — tracking positions and collisions.</summary>
    Racing,

    /// <summary>All participants have finished, been disqualified, or the session was cancelled.</summary>
    Finished
}

/// <summary>
/// Manages the full lifecycle of a single scramble race:
/// accept window → racing → finish/DQ/cancel.
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

    /// <summary>All participants (initiator + accepted players), keyed by SessionId.</summary>
    public Dictionary<byte, ACTcpClient> Participants { get; } = new();

    /// <summary>SessionIds of participants who have been disqualified.</summary>
    public HashSet<byte> DisqualifiedIds { get; } = new();

    /// <summary>SessionIds of participants who have successfully arrived.</summary>
    public HashSet<byte> ArrivedIds { get; } = new();

    private readonly ScrambleConfiguration _config;
    private readonly EntryCarManager _entryCarManager;
    private readonly Action<RaceSession> _onSessionEnd;

    private readonly byte _initiatorSessionId;
    private long _acceptWindowEndsAt;

    /// <summary>
    /// Creates a new race session in AcceptWindow phase.
    /// Only the initiator is enrolled; others must /accept from the same starting area.
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
        Destination   = destination;
        _config            = config;
        _entryCarManager   = entryCarManager;
        _onSessionEnd      = onSessionEnd;
        _initiatorSessionId = initiator.SessionId;

        Participants[initiator.SessionId] = initiator;

        Phase = RacePhase.AcceptWindow;
        _acceptWindowEndsAt = Environment.TickCount64 + config.TimeToAcceptSeconds * 1000L;

        // Send Countdown state to the initiator so they see the GPS compass + accept-window timer
        long raceStartsAt = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds()
                            + config.TimeToAcceptSeconds * 1000L;
        initiator.SendPacket(new ScrambleRaceStateEvent
        {
            RaceState    = RaceState.Countdown,
            DestName     = destination.Name,
            DestX        = destination.Coordinates[0],
            DestY        = destination.Coordinates[1],
            DestZ        = destination.Coordinates[2],
            DestRadius   = destination.Radius,
            RaceStartsAt = raceStartsAt
        });
    }

    /// <summary>
    /// Attempts to add a player who typed /accept during the accept window.
    /// Returns false if the window is closed or the player is already in the race.
    /// </summary>
    public bool TryAccept(ACTcpClient client)
    {
        if (Phase != RacePhase.AcceptWindow) return false;
        if (Participants.ContainsKey(client.SessionId)) return false;

        Participants[client.SessionId] = client;
        Log.Information("ScramblePlugin: {Player} accepted race from {Area} to {Dest}",
            client.Name, StartAreaName, Destination.Name);

        // Send current countdown state so the new participant sees GPS + remaining time
        long remaining    = Math.Max(0, _acceptWindowEndsAt - Environment.TickCount64);
        long raceStartsAt = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds() + remaining;
        client.SendPacket(new ScrambleRaceStateEvent
        {
            RaceState    = RaceState.Countdown,
            DestName     = Destination.Name,
            DestX        = Destination.Coordinates[0],
            DestY        = Destination.Coordinates[1],
            DestZ        = Destination.Coordinates[2],
            DestRadius   = Destination.Radius,
            RaceStartsAt = raceStartsAt
        });

        return true;
    }

    /// <summary>
    /// Called from the service tick loop (~250 ms interval).
    /// Advances the session through its state machine.
    /// </summary>
    public void Tick(EntryCarRaceState[] carStates)
    {
        if (Phase == RacePhase.AcceptWindow)
            TickAcceptWindow(carStates);
    }

    private void TickAcceptWindow(EntryCarRaceState[] carStates)
    {
        if (Environment.TickCount64 < _acceptWindowEndsAt) return;

        // Need at least 1 player other than the initiator
        int otherCount = Participants.Count - 1;

        if (otherCount < 1)
        {
            // Nobody joined — cancel the race
            Phase = RacePhase.Finished;

            if (Participants.TryGetValue(_initiatorSessionId, out var initiator))
            {
                initiator.SendPacket(new ScrambleRaceStateEvent { RaceState = RaceState.Idle });
                carStates[_initiatorSessionId]?.ClearRace();
            }

            _entryCarManager.BroadcastPacket(new ChatMessage
            {
                SessionId = 255,
                Message = $"\u274C Race from {StartAreaName} to {Destination.Name} cancelled \u2014 no one joined."
            });

            Log.Information("ScramblePlugin: Race from {Area} to {Dest} cancelled — no participants joined",
                StartAreaName, Destination.Name);

            _onSessionEnd(this);
            return;
        }

        // At least 1 other player joined — start the race
        Phase = RacePhase.Racing;
        Log.Information("ScramblePlugin: Race from {Area} to {Dest} started with {Count} participants",
            StartAreaName, Destination.Name, Participants.Count);

        // Speed check: DQ anyone moving at race start
        var toDisqualify = new List<byte>();
        foreach (var (sessionId, client) in Participants)
        {
            if (DisqualifiedIds.Contains(sessionId)) continue;
            if (client.EntryCar.Status.Velocity.Length() > _config.MaxStartSpeedMs)
                toDisqualify.Add(sessionId);
        }
        foreach (var sessionId in toDisqualify)
            DisqualifyParticipant(sessionId, Packets.DqReason.MovingAtStart, carStates);

        // Send Racing state to all remaining participants
        foreach (var (sessionId, client) in Participants)
        {
            if (DisqualifiedIds.Contains(sessionId)) continue;
            client.SendPacket(new ScrambleRaceStateEvent
            {
                RaceState    = RaceState.Racing,
                DestName     = Destination.Name,
                DestX        = Destination.Coordinates[0],
                DestY        = Destination.Coordinates[1],
                DestZ        = Destination.Coordinates[2],
                DestRadius   = Destination.Radius,
                RaceStartsAt = 0
            });
            carStates[sessionId]?.ResetForRace();
        }

        int activeCount = Participants.Count - DisqualifiedIds.Count;
        _entryCarManager.BroadcastPacket(new ChatMessage
        {
            SessionId = 255,
            Message = $"\xF0\x9F\x8F\x81 Race started! {activeCount} player{(activeCount == 1 ? "" : "s")} racing from {StartAreaName} to {Destination.Name}!"
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
        int    position = ArrivedIds.Count;
        string name     = client.Name ?? $"Car {sessionId}";

        Log.Information("ScramblePlugin: {Player} arrived at {Dest} in position {Pos}",
            name, Destination.Name, position);

        _entryCarManager.BroadcastPacket(new ChatMessage
        {
            SessionId = 255,
            Message = $"\xF0\x9F\x8F\x81 {name} arrived at {Destination.Name} in position {position}!"
        });

        client.SendPacket(new ScrambleResultEvent
        {
            Status   = ResultStatus.Finished,
            Position = (byte)Math.Min(position, 255),
            DqReason = Packets.DqReason.None
        });

        client.SendPacket(new ScrambleRaceStateEvent { RaceState = RaceState.Idle });
        carStates[sessionId]?.ClearRace();

        CheckSessionComplete();
    }

    /// <summary>
    /// Disqualifies or removes a participant.
    /// During AcceptWindow, cancels the race if the initiator leaves.
    /// </summary>
    public void DisqualifyParticipant(byte sessionId, byte reason, EntryCarRaceState[] carStates)
    {
        if (Phase == RacePhase.AcceptWindow)
        {
            Participants.Remove(sessionId);
            carStates[sessionId]?.ClearRace();

            if (sessionId == _initiatorSessionId)
            {
                // Initiator left — cancel the whole race
                Phase = RacePhase.Finished;
                foreach (var (id, client) in Participants)
                {
                    client.SendPacket(new ScrambleRaceStateEvent { RaceState = RaceState.Idle });
                    carStates[id]?.ClearRace();
                }
                _entryCarManager.BroadcastPacket(new ChatMessage
                {
                    SessionId = 255,
                    Message = $"\u274C Race from {StartAreaName} cancelled \u2014 initiator disconnected."
                });
                _onSessionEnd(this);
            }
            return;
        }

        if (DisqualifiedIds.Contains(sessionId)) return;
        if (!Participants.TryGetValue(sessionId, out var dqClient)) return;

        DisqualifiedIds.Add(sessionId);
        string name       = dqClient.Name ?? $"Car {sessionId}";
        string reasonText = reason switch
        {
            Packets.DqReason.Teleport          => "teleport",
            Packets.DqReason.MovingAtStart     => "moving at race start",
            Packets.DqReason.TooManyCollisions => "too many collisions",
            Packets.DqReason.Disconnected      => "disconnected",
            _                                  => "unknown reason"
        };

        Log.Information("ScramblePlugin: {Player} disqualified — {Reason}", name, reasonText);

        dqClient.SendPacket(new ScrambleResultEvent
        {
            Status   = ResultStatus.Disqualified,
            Position = 0,
            DqReason = reason
        });

        dqClient.SendPacket(new ScrambleRaceStateEvent { RaceState = RaceState.Idle });
        carStates[sessionId]?.ClearRace();

        SendToAllParticipants(new ChatMessage
        {
            SessionId = 255,
            Message = $"\u274C {name} has been disqualified ({reasonText})."
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
            EndSession();
    }

    private void EndSession()
    {
        Phase = RacePhase.Finished;
        Log.Information("ScramblePlugin: Race from {Area} to {Dest} ended", StartAreaName, Destination.Name);
        _onSessionEnd(this);
    }
}
