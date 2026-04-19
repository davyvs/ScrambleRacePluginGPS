using AssettoServer.Network.ClientMessages;

namespace ScramblePlugin.Packets;

/// <summary>
/// Sent only to race participants when their race state changes.
/// Drives the client-side GPS HUD and countdown overlay.
/// </summary>
[OnlineEvent(Key = "scrambleRaceState")]
public class ScrambleRaceStateEvent : OnlineEvent<ScrambleRaceStateEvent>
{
    /// <summary>0 = Idle (clear HUD), 1 = Countdown (race starting), 2 = Racing.</summary>
    [OnlineEventField(Name = "raceState")]
    public byte RaceState;

    /// <summary>Destination display name. Empty when RaceState is Idle.</summary>
    [OnlineEventField(Name = "destName", Size = 64)]
    public string DestName = "";

    /// <summary>Destination world X coordinate. Zero when Idle.</summary>
    [OnlineEventField(Name = "destX")]
    public float DestX;

    /// <summary>Destination world Y coordinate. Zero when Idle.</summary>
    [OnlineEventField(Name = "destY")]
    public float DestY;

    /// <summary>Destination world Z coordinate. Zero when Idle.</summary>
    [OnlineEventField(Name = "destZ")]
    public float DestZ;

    /// <summary>Arrival radius in metres. Used by Lua for local proximity indicator.</summary>
    [OnlineEventField(Name = "destRadius")]
    public float DestRadius;

    /// <summary>
    /// Unix timestamp (milliseconds) at which the countdown ends and racing begins.
    /// Zero when not in countdown phase.
    /// </summary>
    [OnlineEventField(Name = "raceStartsAt")]
    public long RaceStartsAt;
}

/// <summary>Race state values for <see cref="ScrambleRaceStateEvent.RaceState"/>.</summary>
public static class RaceState
{
    public const byte Idle = 0;
    public const byte Countdown = 1;
    public const byte Racing = 2;
}
