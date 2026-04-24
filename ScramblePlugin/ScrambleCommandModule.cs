using AssettoServer.Commands;
using AssettoServer.Commands.Attributes;
using AssettoServer.Shared.Network.Packets.Shared;
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
    private readonly ScrambleConfiguration _config;

    public ScrambleCommandModule(ScrambleService service, ScrambleConfiguration config)
    {
        _service = service;
        _config  = config;
    }

    [Command("scramble")]
    [Description("Start a race from your current starting area. Use /scramble help to list valid areas.")]
    public void Scramble([Remainder] string args = "")
    {
        if (args.Equals("help", StringComparison.OrdinalIgnoreCase))
        {
            ShowHelp();
            return;
        }

        _service.HandleScrambleCommand(Client!);
    }

    [Command("accept")]
    [Description("Join a pending race at your current starting area.")]
    public void Accept()
    {
        _service.HandleAcceptCommand(Client!);
    }

    private void ShowHelp()
    {
        if (_config.StartAreas.Count == 0)
        {
            Client!.SendPacket(new ChatMessage
            {
                SessionId = 255,
                Message   = "No starting areas are configured on this server."
            });
            return;
        }

        var names = string.Join(", ", _config.StartAreas.Select(a => a.Name));
        Client!.SendPacket(new ChatMessage
        {
            SessionId = 255,
            Message   = $"\xF0\x9F\x85\xBF Starting areas: {names}"
        });
        Client!.SendPacket(new ChatMessage
        {
            SessionId = 255,
            Message   = "Drive to one of these parking areas and type /scramble to start a race!"
        });
    }
}
