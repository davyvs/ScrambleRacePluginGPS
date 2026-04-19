using AssettoServer.Network.ClientMessages;

namespace ScramblePlugin.Packets;

/// <summary>
/// Sent only to the individual participant whose race has just ended,
/// either by finishing or by disqualification.
/// </summary>
[OnlineEvent(Key = "scrambleResult")]
public class ScrambleResultEvent : OnlineEvent<ScrambleResultEvent>
{
    /// <summary>0 = Finished, 1 = Disqualified.</summary>
    [OnlineEventField(Name = "status")]
    public byte Status;

    /// <summary>1-based finish position when Status is Finished. 0 when disqualified.</summary>
    [OnlineEventField(Name = "position")]
    public byte Position;

    /// <summary>Disqualification reason code. 0 = not disqualified.</summary>
    [OnlineEventField(Name = "dqReason")]
    public byte DqReason;
}

/// <summary>Result status values for <see cref="ScrambleResultEvent.Status"/>.</summary>
public static class ResultStatus
{
    public const byte Finished = 0;
    public const byte Disqualified = 1;
}

/// <summary>Disqualification reason codes for <see cref="ScrambleResultEvent.DqReason"/>.</summary>
public static class DqReason
{
    public const byte None = 0;
    public const byte Teleport = 1;
    public const byte MovingAtStart = 2;
    public const byte TooManyCollisions = 3;
    public const byte Disconnected = 4;
}
