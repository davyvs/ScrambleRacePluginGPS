using AssettoServer.Server.Plugin;
using Autofac;
using JetBrains.Annotations;

namespace ScramblePlugin;

[UsedImplicitly]
public class ScrambleModule : AssettoServerModule<ScrambleConfiguration>
{
    protected override void Load(ContainerBuilder builder)
    {
        builder.RegisterType<ScrambleService>().AsSelf().As<IAssettoServerAutostart>().SingleInstance();
        builder.RegisterType<EntryCarRaceState>().AsSelf();
    }
}
