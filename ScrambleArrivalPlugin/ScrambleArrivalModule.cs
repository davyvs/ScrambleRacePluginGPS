using AssettoServer.Server.Plugin;
using Autofac;
using Microsoft.Extensions.Hosting;

namespace ScrambleArrivalPlugin;

public class ScrambleArrivalModule : AssettoServerModule<ScrambleArrivalConfiguration>
{
    protected override void Load(ContainerBuilder builder)
    {
        builder.RegisterType<ScrambleArrivalPlugin>()
            .AsSelf()
            .As<IHostedService>()
            .SingleInstance();
    }
}
