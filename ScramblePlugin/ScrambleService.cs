using System.Collections.Concurrent;
using System.Numerics;
using System.Reflection;
using AssettoServer.Network.Tcp;
using AssettoServer.Server;
using AssettoServer.Server.Configuration;
using AssettoServer.Server.Plugin;
using AssettoServer.Shared.Network.Packets.Incoming;
using AssettoServer.Shared.Network.Packets.Shared;
using AssettoServer.Shared.Services;
using JetBrains.Annotations;
using Microsoft.Extensions.Hosting;
using ScramblePlugin.Packets;
using Serilog;

namespace ScramblePlugin;

/// <summary>
/// Main ScramblePlugin service. Manages race sessions, serves the GPS Lua script,
/// and handles all server-side race logic including DQ detection and arrival tracking.
/// </summary>
[UsedImplicitly]
public class ScrambleService : CriticalBackgroundService, IAssettoServerAutostart
{
    private readonly EntryCarManager _entryCarManager;
    private readonly ScrambleConfiguration _config;
    private readonly ACServerConfiguration _serverConfiguration;
    private readonly Func<EntryCar, EntryCarRaceState> _carStateFactory;

    // Per-car state indexed by SessionId
    private readonly EntryCarRaceState[] _carStates = new EntryCarRaceState[256];

    // Active race sessions keyed by StartArea.Name
    private readonly ConcurrentDictionary<string, RaceSession> _activeSessions = new();

    // Pre-built destination lookup (case-insensitive, includes legacy promotions)
    private readonly Dictionary<string, DestinationConfig> _destinations;

    // Starting area list (including AlsoDestination areas)
    private readonly List<StartAreaConfig> _startAreas;

    public ScrambleService(
        EntryCarManager entryCarManager,
        ScrambleConfiguration config,
        ACServerConfiguration serverConfiguration,
        CSPServerScriptProvider scriptProvider,
        Func<EntryCar, EntryCarRaceState> carStateFactory,
        IHostApplicationLifetime applicationLifetime) : base(applicationLifetime)
    {
        _entryCarManager = entryCarManager;
        _config = config;
        _serverConfiguration = serverConfiguration;
        _carStateFactory = carStateFactory;

        // Legacy promotion: if Destinations is empty, build from Maps
        var destinations = config.Destinations.Count > 0
            ? config.Destinations
            : PromoteLegacyMaps(config);

        _destinations = destinations.ToDictionary(
            d => d.Name,
            d => d,
            StringComparer.OrdinalIgnoreCase);

        _startAreas = new List<StartAreaConfig>(config.StartAreas);

        // Serve the embedded GPS Lua script if CSP client messages are enabled
        if (serverConfiguration.Extra.EnableClientMessages)
        {
            using var stream = Assembly.GetExecutingAssembly()
                .GetManifestResourceStream("ScramblePlugin.lua.scramble_gps.lua");

            if (stream != null)
            {
                scriptProvider.AddScript(stream, "scramble_gps.lua", new Dictionary<string, object>
                {
                    ["SCRAMBLE_PLUGIN"] = "1",
                    ["MAP"] = config.MapId
                });
                Log.Information("ScramblePlugin: GPS Lua script registered (map: {Map})", config.MapId);
            }
            else
            {
                Log.Warning("ScramblePlugin: Could not find embedded scramble_gps.lua resource");
            }
        }

        int destCount = _destinations.Count;
        int areaCount = _startAreas.Count;
        Log.Information("ScramblePlugin: Loaded {Destinations} destination(s) and {Areas} starting area(s)",
            destCount, areaCount);
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        // Create per-car state and subscribe events for all existing slots
        foreach (var car in _entryCarManager.EntryCars)
        {
            InitCar(car);
        }

        // Subscribe to future connections
        _entryCarManager.ClientConnected += OnClientConnected;

        Log.Information("ScramblePlugin: Running");

        // Main tick loop — advances race session state machines
        while (!stoppingToken.IsCancellationRequested)
        {
            foreach (var session in _activeSessions.Values)
            {
                session.Tick(_carStates);
            }
            await Task.Delay(250, stoppingToken);
        }
    }

    // ── Client lifecycle ──────────────────────────────────────────────────────

    private void InitCar(EntryCar car)
    {
        _carStates[car.SessionId] = _carStateFactory(car);
        car.PositionUpdateReceived += OnPositionUpdate;
    }

    private void OnClientConnected(ACTcpClient client, EventArgs _)
    {
        // Re-init the car state for this slot (may have been used by a previous player)
        _carStates[client.SessionId] = _carStateFactory(client.EntryCar);
        client.EntryCar.PositionUpdateReceived += OnPositionUpdate;
        client.Collision += OnCollision;
        client.Disconnecting += OnClientDisconnecting;

        // Hook legacy !scramble chat commands
        client.ChatMessageReceived += OnChatMessage;
    }

    private void OnClientDisconnecting(ACTcpClient client, EventArgs _)
    {
        var state = _carStates[client.SessionId];
        if (state?.ActiveSession is { } session)
        {
            session.DisqualifyParticipant(client.SessionId, DqReason.Disconnected, _carStates);
        }
    }

    // ── Position update ───────────────────────────────────────────────────────

    private void OnPositionUpdate(EntryCar car, in PositionUpdateIn update)
    {
        var state = _carStates[car.SessionId];
        if (state == null) return;

        Vector3 newPos = update.Position;

        // Teleport detection — only while actively racing
        if (state.IsRacing && state.HasPosition)
        {
            float delta = Vector3.Distance(newPos, state.LastKnownPosition);
            if (delta > _config.TeleportThresholdMeters)
            {
                Log.Information("ScramblePlugin: Teleport detected for car {SessionId} (delta {Delta:F1} m)",
                    car.SessionId, delta);
                state.ActiveSession?.DisqualifyParticipant(car.SessionId, DqReason.Teleport, _carStates);
            }
        }

        state.LastKnownPosition = newPos;
        state.HasPosition = true;

        // Arrival detection — only while actively racing
        if (state.IsRacing && state.ActiveSession is { } session)
        {
            var dest = session.Destination;
            var destPos = new Vector3(dest.Coordinates[0], dest.Coordinates[1], dest.Coordinates[2]);
            float distance = Vector3.Distance(newPos, destPos);
            if (distance <= dest.Radius)
            {
                session.RecordArrival(car.SessionId, _carStates);
            }
        }
    }

    // ── Collision detection ───────────────────────────────────────────────────

    private void OnCollision(ACTcpClient sender, CollisionEventArgs e)
    {
        if (_config.CollisionDQLimit <= 0) return;

        var state = _carStates[sender.SessionId];
        if (state == null || !state.IsRacing) return;

        state.CollisionCount++;
        Log.Debug("ScramblePlugin: Collision #{Count} for {Player}", state.CollisionCount, sender.Name);

        if (state.CollisionCount >= _config.CollisionDQLimit)
        {
            state.ActiveSession?.DisqualifyParticipant(
                sender.SessionId, DqReason.TooManyCollisions, _carStates);
        }
    }

    // ── Chat commands (public — called from ScrambleCommandModule) ─────────────

    /// <summary>
    /// Handles a player typing /scramble. Validates they are in a starting area
    /// and no race is already in progress there, then creates a new <see cref="RaceSession"/>.
    /// </summary>
    public void HandleScrambleCommand(ACTcpClient client)
    {
        var state = _carStates[client.SessionId];
        if (state == null) return;

        // Reject if no starting areas configured (legacy-only mode)
        if (_startAreas.Count == 0)
        {
            client.SendPacket(new ChatMessage
            {
                SessionId = 255,
                Message = "No starting areas are configured on this server."
            });
            return;
        }

        // Find the starting area the player is currently in
        var area = PolygonContainment.FindContainingArea(_startAreas, state.LastKnownPosition);
        if (area == null)
        {
            client.SendPacket(new ChatMessage
            {
                SessionId = 255,
                Message = "You must be in a starting area to begin a race."
            });
            return;
        }

        // Reject if a race is already running from this area
        if (_activeSessions.ContainsKey(area.Name))
        {
            client.SendPacket(new ChatMessage
            {
                SessionId = 255,
                Message = $"A race from {area.Name} is already in progress."
            });
            return;
        }

        // Pick a destination — for now, use the first configured destination.
        // Future: allow destination selection via command argument.
        if (_destinations.Count == 0)
        {
            client.SendPacket(new ChatMessage
            {
                SessionId = 255,
                Message = "No destinations are configured on this server."
            });
            return;
        }

        var destination = _destinations.Values.First();

        var session = new RaceSession(
            area.Name,
            destination,
            client,
            _config,
            _entryCarManager,
            OnSessionEnd);

        _activeSessions[area.Name] = session;
        state.ActiveSession = session;

        string playerName = client.Name ?? $"Car {client.SessionId}";
        _entryCarManager.BroadcastPacket(new ChatMessage
        {
            SessionId = 255,
            Message = $"\xF0\x9F\x8F\x81 {playerName} is starting a race from {area.Name}! " +
                      $"Go there and type /accept to join. ({_config.TimeToAcceptSeconds}s)"
        });

        Log.Information("ScramblePlugin: Race initiated by {Player} from {Area} to {Dest}",
            playerName, area.Name, destination.Name);
    }

    /// <summary>
    /// Handles a player typing /accept. Validates they are in the same starting area
    /// as an open race, then adds them as a participant.
    /// </summary>
    public void HandleAcceptCommand(ACTcpClient client)
    {
        var state = _carStates[client.SessionId];
        if (state == null) return;

        var area = PolygonContainment.FindContainingArea(_startAreas, state.LastKnownPosition);
        if (area == null || !_activeSessions.TryGetValue(area.Name, out var session))
        {
            client.SendPacket(new ChatMessage
            {
                SessionId = 255,
                Message = "No race to join from your current position."
            });
            return;
        }

        if (!session.IsAcceptWindowOpen)
        {
            client.SendPacket(new ChatMessage
            {
                SessionId = 255,
                Message = "The join window for this race has closed."
            });
            return;
        }

        if (session.Participants.ContainsKey(client.SessionId))
        {
            client.SendPacket(new ChatMessage
            {
                SessionId = 255,
                Message = "You have already joined this race."
            });
            return;
        }

        session.AddParticipant(client);
        state.ActiveSession = session;
    }

    // ── Legacy !scramble chat command handling ────────────────────────────────

    private void OnChatMessage(ACTcpClient sender, ChatMessageEventArgs e)
    {
        string msg = e.ChatMessage.Message?.Trim() ?? "";
        if (!msg.StartsWith("!scramble ", StringComparison.OrdinalIgnoreCase)) return;

        string arg = msg["!scramble ".Length..].Trim();

        if (arg.Equals("clear", StringComparison.OrdinalIgnoreCase))
        {
            // Legacy clear: send Idle to the requesting player
            sender.SendPacket(new ScrambleRaceStateEvent { RaceState = RaceState.Idle });
            return;
        }

        int colonIdx = arg.IndexOf(':');
        if (colonIdx < 0) return;

        string destName = arg[(colonIdx + 1)..].Trim().Replace('_', ' ');
        if (!_destinations.TryGetValue(destName, out var dest)) return;

        // Legacy mode: send Racing state directly to the requesting player only
        sender.SendPacket(new ScrambleRaceStateEvent
        {
            RaceState = RaceState.Racing,
            DestName = dest.Name,
            DestX = dest.Coordinates[0],
            DestY = dest.Coordinates[1],
            DestZ = dest.Coordinates[2],
            DestRadius = dest.Radius,
            RaceStartsAt = 0
        });
    }

    // ── Session lifecycle ─────────────────────────────────────────────────────

    private void OnSessionEnd(RaceSession session)
    {
        _activeSessions.TryRemove(session.StartAreaName, out _);
    }

    // ── Legacy promotion ──────────────────────────────────────────────────────

    private static List<DestinationConfig> PromoteLegacyMaps(ScrambleConfiguration config)
    {
        var promoted = new List<DestinationConfig>();
        foreach (var map in config.Maps.Values)
        {
            foreach (var (name, coords) in map)
            {
                if (coords.Length < 3) continue;
                promoted.Add(new DestinationConfig
                {
                    Name = name,
                    Radius = config.ArrivalRadiusMeters,
                    Coordinates = coords
                });
            }
        }

        if (promoted.Count > 0)
        {
            Log.Information("ScramblePlugin: Auto-promoted {Count} legacy destinations from Maps config",
                promoted.Count);
        }

        return promoted;
    }
}
