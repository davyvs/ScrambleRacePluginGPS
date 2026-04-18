using System.Numerics;
using AssettoServer.Network.Tcp;
using AssettoServer.Server;
using AssettoServer.Shared.Network.Packets.Incoming;
using AssettoServer.Shared.Network.Packets.Shared;
using Microsoft.Extensions.Hosting;
using Serilog;

namespace ScrambleArrivalPlugin;

/// <summary>
/// Server-side arrival detection for Scramble GPS races.
/// Listens for !scramble commands in chat, tracks car positions server-side,
/// and broadcasts 🏁 arrival messages as SessionId 255 (server) so clients
/// cannot fake arrivals by editing local coordinates.
/// </summary>
public class ScrambleArrivalPlugin : BackgroundService
{
    private readonly EntryCarManager _entryCarManager;
    private readonly ScrambleArrivalConfiguration _config;

    // Flat lookup: destination name → position (built once from config)
    private readonly Dictionary<string, Vector3> _destLookup = new(StringComparer.OrdinalIgnoreCase);

    // Active race state — use a wrapper class so we can swap atomically via volatile
    private sealed class ActiveRace
    {
        public readonly string Name;
        public readonly Vector3 Position;
        public ActiveRace(string name, Vector3 pos) { Name = name; Position = pos; }
    }

    private volatile ActiveRace? _activeRace;

    // Per-session arrival flag — bool[] is safe to read/write without locks in .NET
    private readonly bool[] _arrived = new bool[256];

    public ScrambleArrivalPlugin(EntryCarManager entryCarManager, ScrambleArrivalConfiguration config)
    {
        _entryCarManager = entryCarManager;
        _config = config;

        // Build flat lookup from all maps
        foreach (var (_, dests) in _config.Maps)
        {
            foreach (var (name, coords) in dests)
            {
                if (coords.Length >= 3)
                    _destLookup[name] = new Vector3(coords[0], coords[1], coords[2]);
            }
        }

        Log.Information("ScrambleArrivalPlugin: loaded {Count} destinations from {Maps} map(s)",
            _destLookup.Count, _config.Maps.Count);

        // Subscribe to existing cars and attach handlers for future clients
        foreach (var car in _entryCarManager.EntryCars)
        {
            car.PositionUpdateReceived += OnPositionUpdate;
        }

        _entryCarManager.ClientConnected += (client, _) =>
        {
            client.ChatMessageReceived += OnChatMessage;
        };
    }

    protected override Task ExecuteAsync(CancellationToken stoppingToken)
        => Task.Delay(Timeout.Infinite, stoppingToken);

    // ── Chat handler ──────────────────────────────────────────────────────────

    private void OnChatMessage(ACTcpClient sender, ChatMessageEventArgs e)
    {
        var msg = e.ChatMessage.Message.AsSpan().Trim();
        if (!msg.StartsWith("!scramble ", StringComparison.Ordinal))
            return;

        var arg = msg["!scramble ".Length..].Trim();

        if (arg.Equals("clear", StringComparison.Ordinal))
        {
            _activeRace = null;
            Array.Clear(_arrived);
            Log.Debug("ScrambleArrivalPlugin: race cleared by {Player}", sender.Name);
            return;
        }

        // Formats: p2p:DEST  |  convoy:DEST  |  lap:ROUTE  |  catmouse:NAME
        var colonIdx = arg.IndexOf(':');
        if (colonIdx < 0) return;

        var destName = arg[(colonIdx + 1)..].Trim().ToString();
        SetDestination(destName);
    }

    private void SetDestination(string destName)
    {
        Array.Clear(_arrived);

        if (_destLookup.TryGetValue(destName, out var pos))
        {
            _activeRace = new ActiveRace(destName, pos);
            Log.Information("ScrambleArrivalPlugin: tracking arrivals at '{Dest}' ({Pos})", destName, pos);
        }
        else
        {
            // Destination not in config — disable server-side tracking
            _activeRace = null;
            Log.Warning("ScrambleArrivalPlugin: destination '{Dest}' not found in config, arrival tracking disabled", destName);
        }
    }

    // ── Position update handler ───────────────────────────────────────────────

    private void OnPositionUpdate(EntryCar car, in PositionUpdateIn update)
    {
        var race = _activeRace;
        if (race is null) return;
        if (_arrived[car.SessionId]) return;

        if (Vector3.Distance(update.Position, race.Position) < _config.ArrivalRadiusMeters)
        {
            _arrived[car.SessionId] = true;
            var name = car.Client?.Name ?? $"Car {car.SessionId}";
            Log.Information("ScrambleArrivalPlugin: {Player} arrived at {Dest}", name, race.Name);

            _entryCarManager.BroadcastPacket(new ChatMessage
            {
                SessionId = 255,
                Message = $"\xF0\x9F\x8F\x81 {name} arrived at {race.Name}!"
            });
        }
    }
}
