using AssettoServer.Commands;
using AssettoServer.Commands.Attributes;
using JetBrains.Annotations;
using Qmmands;

namespace ScramblePlugin;

/// <summary>Chat command handlers for /scramble and /accept.</summary>
[UsedImplicitly]
public class ScrambleCommandModule : ACModuleBase
{
    private readonly ScrambleService _service;

    public ScrambleCommandModule(ScrambleService service)
    {
        _service = service;
    }

    /// <summary>Initiates a scramble race from the player's current starting area.</summary>
    [Command("scramble")]
    [RequireConnectedPlayer]
    public void Scramble()
        => _service.HandleScrambleCommand(Client!);

    /// <summary>Joins an open race being initiated in the player's current starting area.</summary>
    [Command("accept")]
    [RequireConnectedPlayer]
    public void Accept()
        => _service.HandleAcceptCommand(Client!);
}
