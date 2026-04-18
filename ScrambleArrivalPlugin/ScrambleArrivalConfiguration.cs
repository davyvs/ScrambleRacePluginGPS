namespace ScrambleArrivalPlugin;

public class ScrambleArrivalConfiguration
{
    /// <summary>
    /// Distance in metres from destination centre that counts as arrival.
    /// </summary>
    public float ArrivalRadiusMeters { get; init; } = 150f;

    /// <summary>
    /// Map ID → destination name → [X, Y, Z] coordinates.
    /// Matches the MAP= value in csp_extra_options.ini and the destination names used in !scramble commands.
    /// </summary>
    public Dictionary<string, Dictionary<string, float[]>> Maps { get; init; } = new();
}
