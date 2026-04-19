using System.Numerics;
using AssettoServer.Server;

namespace ScramblePlugin;

/// <summary>Per-car mutable state tracked by ScramblePlugin throughout a race.</summary>
public class EntryCarRaceState
{
    /// <summary>The car this state belongs to.</summary>
    public EntryCar EntryCar { get; }

    /// <summary>The active race session this car is participating in, or <c>null</c> when not racing.</summary>
    public RaceSession? ActiveSession { get; set; }

    /// <summary>Returns <c>true</c> when this car is in an active Racing phase.</summary>
    public bool IsRacing => ActiveSession?.Phase == RacePhase.Racing;

    /// <summary>Last known world-space position, updated on every position event.</summary>
    public Vector3 LastKnownPosition { get; set; }

    /// <summary>
    /// Whether <see cref="LastKnownPosition"/> has been set at least once.
    /// Prevents false teleport DQs on the first position update after connecting.
    /// </summary>
    public bool HasPosition { get; set; }

    /// <summary>Number of environment collisions recorded during the current race.</summary>
    public int CollisionCount { get; set; }

    public EntryCarRaceState(EntryCar entryCar)
    {
        EntryCar = entryCar;
    }

    /// <summary>Resets counters when this car joins a new race.</summary>
    public void ResetForRace()
    {
        CollisionCount = 0;
    }

    /// <summary>Clears all race tracking state when the car leaves a race.</summary>
    public void ClearRace()
    {
        ActiveSession = null;
        CollisionCount = 0;
    }
}
