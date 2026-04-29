using AssettoServer.Server.Plugin;
using Autofac;
using JetBrains.Annotations;

namespace ScramblePlugin;

[UsedImplicitly]
public class ScrambleModule : AssettoServerModule<ScrambleConfiguration>
{
    protected override void Load(ContainerBuilder builder)
    {
#if ASSERVER_055
        builder.RegisterType<ScrambleService>().AsSelf().As<Microsoft.Extensions.Hosting.IHostedService>().SingleInstance();
#else
        builder.RegisterType<ScrambleService>().AsSelf().As<IAssettoServerAutostart>().SingleInstance();
#endif
        builder.RegisterType<EntryCarRaceState>().AsSelf();
        builder.RegisterType<ScrambleCommandModule>().AsSelf();
    }
}
