using AssettoServer.Server.Configuration;
using JetBrains.Annotations;

namespace ScramblePlugin;

/// <summary>Configuration for ScramblePlugin — unified race management, GPS HUD, and arrival detection.</summary>
[UsedImplicitly(ImplicitUseKindFlags.Assign, ImplicitUseTargetFlags.WithMembers)]
public class ScrambleConfiguration : IValidateConfiguration<ScrambleConfigurationValidator>
{
    // ── Race timing ───────────────────────────────────────────────────────────

    /// <summary>Countdown duration in seconds after /scramble is initiated before the race starts.</summary>
    public int TimeToAcceptSeconds { get; init; } = 30;

    /// <summary>
    /// Minimum number of participants (including the initiator) required to start a race.
    /// Set to 1 to allow solo racing (useful for testing). Default is 1.
    /// </summary>
    public int MinParticipants { get; init; } = 1;

    /// <summary>Number of environment collisions before a participant is disqualified. 0 = disabled.</summary>
    public int CollisionDQLimit { get; init; } = 0;

    /// <summary>
    /// Single-frame position delta (metres) that is treated as a teleport and triggers DQ.
    /// AC's built-in "reset to track" can move the car 200–400 m, so keep this high enough
    /// to avoid false positives. Set to 0 to disable teleport DQ entirely.
    /// </summary>
    public float TeleportThresholdMeters { get; init; } = 500f;

    /// <summary>Maximum speed (m/s) allowed at race start. Participants moving faster are disqualified.</summary>
    public float MaxStartSpeedMs { get; init; } = 2.0f;

    // ── Map identifier (injected into Lua script) ─────────────────────────────

    /// <summary>Map identifier passed to the GPS Lua script. E.g. "shutoko" or "sdc".</summary>
    public string MapId { get; init; } = "shutoko";

    // ── Destinations ──────────────────────────────────────────────────────────

    /// <summary>Named race destinations. Can optionally also act as starting areas.</summary>
    public List<DestinationConfig> Destinations { get; init; } = new();

    // ── Starting areas ────────────────────────────────────────────────────────

    /// <summary>Polygon-defined areas from which a race can be initiated with /scramble.</summary>
    public List<StartAreaConfig> StartAreas { get; init; } = new();

    // ── Legacy compatibility ──────────────────────────────────────────────────

    /// <summary>
    /// Arrival detection radius used when processing legacy !scramble chat commands
    /// and when auto-promoting entries from the <see cref="Maps"/> dictionary.
    /// </summary>
    public float ArrivalRadiusMeters { get; init; } = 150f;

    /// <summary>
    /// Legacy map→destination→coordinates lookup (from ScrambleArrivalConfiguration).
    /// If <see cref="Destinations"/> is empty, entries are auto-promoted to
    /// <see cref="DestinationConfig"/> objects at startup using <see cref="ArrivalRadiusMeters"/>.
    /// </summary>
    public Dictionary<string, Dictionary<string, float[]>> Maps { get; init; } = new();
}

/// <summary>A named destination that can be used as a race endpoint.</summary>
[UsedImplicitly(ImplicitUseKindFlags.Assign, ImplicitUseTargetFlags.WithMembers)]
public class DestinationConfig
{
    /// <summary>Unique display name shown in chat and GPS HUD.</summary>
    public required string Name { get; init; }

    /// <summary>Arrival detection radius in metres.</summary>
    public float Radius { get; init; } = 10f;

    /// <summary>World-space coordinates as [X, Y, Z].</summary>
    public float[] Coordinates { get; init; } = Array.Empty<float>();

    /// <summary>If true, this destination is also treated as a valid starting area (circular polygon).</summary>
    public bool AlsoStartArea { get; init; } = false;
}

/// <summary>A polygon-defined area from which races can be initiated.</summary>
[UsedImplicitly(ImplicitUseKindFlags.Assign, ImplicitUseTargetFlags.WithMembers)]
public class StartAreaConfig
{
    /// <summary>Display name shown in the race-start broadcast message.</summary>
    public required string Name { get; init; }

    /// <summary>
    /// Polygon vertices in world space. Each entry is [X, Y, Z] — the Y component
    /// is ignored and the containment test is performed on the XZ plane.
    /// Minimum 3 vertices required.
    /// </summary>
    public List<float[]> Vertices { get; init; } = new();

    /// <summary>If true, the centroid of this area is also registered as a destination.</summary>
    public bool AlsoDestination { get; init; } = false;
}
