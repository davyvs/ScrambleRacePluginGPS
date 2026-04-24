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

    // Active race sessions keyed by StartArea.Name (one race per area, one active total)
    private readonly ConcurrentDictionary<string, RaceSession> _activeSessions = new();

    // Pre-built destination lookup (case-insensitive, includes legacy promotions)
    private readonly Dictionary<string, DestinationConfig> _destinations;

    // Starting area list
    private readonly List<StartAreaConfig> _startAreas;

    // Random source for destination selection
    private readonly Random _rng = new();

    public ScrambleService(
        EntryCarManager entryCarManager,
        ScrambleConfiguration config,
        ACServerConfiguration serverConfiguration,
        CSPServerScriptProvider scriptProvider,
        Func<EntryCar, EntryCarRaceState> carStateFactory,
        IHostApplicationLifetime applicationLifetime) : base(applicationLifetime)
    {
        _entryCarManager = entryCarManager;
        _config          = config;
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

        Log.Information("ScramblePlugin: Loaded {Destinations} destination(s) and {Areas} starting area(s)",
            _destinations.Count, _startAreas.Count);
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        foreach (var car in _entryCarManager.EntryCars)
            InitCar(car);

        _entryCarManager.ClientConnected += OnClientConnected;

        Log.Information("ScramblePlugin: Running");

        while (!stoppingToken.IsCancellationRequested)
        {
            foreach (var session in _activeSessions.Values)
                session.Tick(_carStates);

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
        _carStates[client.SessionId] = _carStateFactory(client.EntryCar);
        client.EntryCar.PositionUpdateReceived += OnPositionUpdate;
        client.Collision    += OnCollision;
        client.Disconnecting += OnClientDisconnecting;
        client.ChatMessageReceived += OnChatMessage;
    }

    private void OnClientDisconnecting(ACTcpClient client, EventArgs _)
    {
        var state = _carStates[client.SessionId];
        if (state?.ActiveSession is { } session)
            session.DisqualifyParticipant(client.SessionId, DqReason.Disconnected, _carStates);
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
        if (state.IsRacing && state.ActiveSession is { } activeSession)
        {
            var dest    = activeSession.Destination;
            var destPos = new Vector3(dest.Coordinates[0], dest.Coordinates[1], dest.Coordinates[2]);
            if (Vector3.Distance(newPos, destPos) <= dest.Radius)
                activeSession.RecordArrival(car.SessionId, _carStates);
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
            state.ActiveSession?.DisqualifyParticipant(sender.SessionId, DqReason.TooManyCollisions, _carStates);
    }

    // ── Chat commands ─────────────────────────────────────────────────────────

    private void OnChatMessage(ACTcpClient sender, ChatMessageEventArgs e)
    {
        string msg = e.ChatMessage.Message?.Trim() ?? "";

        // /scramble and /accept are handled by ScrambleCommandModule (proper slash command registration).
        // We still handle the legacy !scramble prefix here for GPS-only convoy/lap/catmouse/clear modes.

        // Legacy GPS-only commands (panel convoy / lap / catmouse / clear)
        if (!msg.StartsWith("!scramble ", StringComparison.OrdinalIgnoreCase)) return;

        string arg = msg["!scramble ".Length..].Trim();

        if (arg.Equals("clear", StringComparison.OrdinalIgnoreCase))
        {
            sender.SendPacket(new ScrambleRaceStateEvent { RaceState = RaceState.Idle });
            return;
        }

        int colonIdx = arg.IndexOf(':');
        if (colonIdx < 0) return;

        string destName = arg[(colonIdx + 1)..].Trim().Replace('_', ' ');
        if (!_destinations.TryGetValue(destName, out var dest)) return;

        // Legacy GPS-only mode: send Racing state to requesting player only (no race tracking)
        sender.SendPacket(new ScrambleRaceStateEvent
        {
            RaceState    = RaceState.Racing,
            DestName     = dest.Name,
            DestX        = dest.Coordinates[0],
            DestY        = dest.Coordinates[1],
            DestZ        = dest.Coordinates[2],
            DestRadius   = dest.Radius,
            RaceStartsAt = 0
        });
    }

    // ── /scramble ─────────────────────────────────────────────────────────────

    /// <summary>
    /// Handles /scramble: validates the player is in a starting area, picks a random
    /// destination, and opens an accept window for other players to /accept.
    /// Called by ScrambleCommandModule so the slash command is properly registered.
    /// </summary>
    internal void HandleScrambleCommand(ACTcpClient client)
    {
        var state = _carStates[client.SessionId];
        if (state == null) return;

        // Global race lock — only 1 race active at a time across the whole server
        if (_activeSessions.Count > 0)
        {
            client.SendPacket(new ChatMessage
            {
                SessionId = 255,
                Message = "A race is already in progress on this server."
            });
            return;
        }

        // Player already in a race
        if (state.ActiveSession != null)
        {
            client.SendPacket(new ChatMessage { SessionId = 255, Message = "You are already in a race." });
            return;
        }

        // Require StartAreas to be configured
        if (_startAreas.Count == 0)
        {
            client.SendPacket(new ChatMessage
            {
                SessionId = 255,
                Message = "No starting areas are configured on this server."
            });
            return;
        }

        // Player must be inside a starting area polygon
        var area = PolygonContainment.FindContainingArea(_startAreas, state.LastKnownPosition);
        if (area == null)
        {
            client.SendPacket(new ChatMessage
            {
                SessionId = 255,
                Message = "You must be in a starting area to begin a race. Drive to a parking area first!"
            });
            return;
        }

        // No destinations configured
        if (_destinations.Count == 0)
        {
            client.SendPacket(new ChatMessage { SessionId = 255, Message = "No destinations are configured on this server." });
            return;
        }

        // Pick a random destination
        var destList    = _destinations.Values.ToList();
        var destination = destList[_rng.Next(destList.Count)];

        var session = new RaceSession(area.Name, destination, client, _config, _entryCarManager, OnSessionEnd);
        _activeSessions[area.Name] = session;
        state.ActiveSession = session;

        string playerName = client.Name ?? $"Car {client.SessionId}";
        _entryCarManager.BroadcastPacket(new ChatMessage
        {
            SessionId = 255,
            Message = $"\xF0\x9F\x8F\x81 {playerName} is starting a race from {area.Name} to {destination.Name}! " +
                      $"Go to {area.Name} and type /join to join! ({_config.TimeToAcceptSeconds}s)"
        });

        Log.Information("ScramblePlugin: Race initiated by {Player} from {Area} to {Dest}",
            playerName, area.Name, destination.Name);
    }

    // ── /accept ───────────────────────────────────────────────────────────────

    /// <summary>
    /// Handles /accept: joins the player to a pending race at their current starting area.
    /// Called by ScrambleCommandModule so the slash command is properly registered.
    /// </summary>
    internal void HandleAcceptCommand(ACTcpClient client)
    {
        var state = _carStates[client.SessionId];
        if (state == null) return;

        if (state.ActiveSession != null)
        {
            client.SendPacket(new ChatMessage { SessionId = 255, Message = "You are already in a race." });
            return;
        }

        // Find which starting area the player is currently in
        var playerArea = PolygonContainment.FindContainingArea(_startAreas, state.LastKnownPosition);
        if (playerArea == null)
        {
            client.SendPacket(new ChatMessage
            {
                SessionId = 255,
                Message = "You must be in a starting area to /join. Drive to the starting area first!"
            });
            return;
        }

        // Check if there's a pending race at that area
        if (!_activeSessions.TryGetValue(playerArea.Name, out var session) ||
            session.Phase != RacePhase.AcceptWindow)
        {
            client.SendPacket(new ChatMessage
            {
                SessionId = 255,
                Message = $"No race is accepting players at {playerArea.Name}."
            });
            return;
        }

        if (!session.TryAccept(client))
        {
            client.SendPacket(new ChatMessage
            {
                SessionId = 255,
                Message = "Could not join the race — it may have already started."
            });
            return;
        }

        state.ActiveSession = session;

        string playerName = client.Name ?? $"Car {client.SessionId}";
        int count = session.Participants.Count;
        _entryCarManager.BroadcastPacket(new ChatMessage
        {
            SessionId = 255,
            Message = $"\u2705 {playerName} joined the race to {session.Destination.Name}! " +
                      $"({count} participant{(count == 1 ? "" : "s")})"
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

        // Only promote destinations for the current map (MapId).
        // If MapId isn't found, fall back to all maps so nothing silently breaks.
        if (!config.Maps.TryGetValue(config.MapId, out var mapEntries))
        {
            Log.Warning("ScramblePlugin: MapId '{MapId}' not found in Maps config — falling back to all map entries", config.MapId);
            foreach (var map in config.Maps.Values)
                foreach (var (name, coords) in map)
                {
                    if (coords.Length < 3) continue;
                    promoted.Add(new DestinationConfig { Name = name, Radius = config.ArrivalRadiusMeters, Coordinates = coords });
                }
        }
        else
        {
            foreach (var (name, coords) in mapEntries)
            {
                if (coords.Length < 3) continue;
                promoted.Add(new DestinationConfig { Name = name, Radius = config.ArrivalRadiusMeters, Coordinates = coords });
            }
        }

        if (promoted.Count > 0)
            Log.Information("ScramblePlugin: Auto-promoted {Count} legacy destinations from Maps[{MapId}]",
                promoted.Count, config.MapId);

        return promoted;
    }
}
