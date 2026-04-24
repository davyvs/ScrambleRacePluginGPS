using AssettoServer.Commands;
using AssettoServer.Commands.Attributes;
using AssettoServer.Network.Tcp;
using JetBrains.Annotations;
using Qmmands;

namespace ScramblePlugin;

/// <summary>
/// Registers /scramble and /accept as proper AssettoServer chat commands.
/// This prevents the "No command found" error that appears when using the
/// ChatMessageReceived event approach for slash commands.
/// </summary>
[UsedImplicitly]
[RequireConnectedPlayer]
public class ScrambleCommandModule : ACModuleBase
{
    private readonly ScrambleService _service;

    public ScrambleCommandModule(ScrambleService service)
    {
        _service = service;
    }

    [Command("scramble")]
    [Description("Start a point-to-point race from your current starting area.")]
    public void Scramble()
    {
        _service.HandleScrambleCommand(Client!);
    }

    [Command("accept")]
    [Description("Join a pending race at your current starting area.")]
    public void Accept()
    {
        _service.HandleAcceptCommand(Client!);
    }
}
