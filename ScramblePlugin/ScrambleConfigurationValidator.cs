using FluentValidation;
using JetBrains.Annotations;

namespace ScramblePlugin;

[UsedImplicitly]
public class ScrambleConfigurationValidator : AbstractValidator<ScrambleConfiguration>
{
    public ScrambleConfigurationValidator()
    {
        RuleFor(c => c.TimeToAcceptSeconds)
            .InclusiveBetween(5, 300)
            .WithMessage("TimeToAcceptSeconds must be between 5 and 300.");

        RuleFor(c => c.CollisionDQLimit)
            .GreaterThanOrEqualTo(0)
            .WithMessage("CollisionDQLimit must be 0 (disabled) or a positive number.");

        RuleFor(c => c.TeleportThresholdMeters)
            .GreaterThan(0)
            .WithMessage("TeleportThresholdMeters must be greater than 0.");

        RuleFor(c => c.MaxStartSpeedMs)
            .GreaterThanOrEqualTo(0)
            .WithMessage("MaxStartSpeedMs must be 0 or greater.");

        RuleFor(c => c.ArrivalRadiusMeters)
            .GreaterThan(0)
            .WithMessage("ArrivalRadiusMeters must be greater than 0.");

        RuleFor(c => c.MapId)
            .NotEmpty()
            .WithMessage("MapId must not be empty.");

        RuleForEach(c => c.Destinations).ChildRules(dest =>
        {
            dest.RuleFor(d => d.Name).NotEmpty().WithMessage("Destination Name must not be empty.");
            dest.RuleFor(d => d.Coordinates).Must(c => c.Length == 3)
                .WithMessage(d => $"Destination '{d.Name}' Coordinates must have exactly 3 values [X, Y, Z].");
            dest.RuleFor(d => d.Radius).GreaterThan(0)
                .WithMessage(d => $"Destination '{d.Name}' Radius must be greater than 0.");
        });

        RuleForEach(c => c.StartAreas).ChildRules(area =>
        {
            area.RuleFor(a => a.Name).NotEmpty().WithMessage("StartArea Name must not be empty.");
            area.RuleFor(a => a.Vertices).Must(v => v.Count >= 3)
                .WithMessage(a => $"StartArea '{a.Name}' must have at least 3 vertices.");
            area.RuleForEach(a => a.Vertices).Must(v => v.Length >= 2)
                .WithMessage(a => $"StartArea '{a.Name}' vertices must each have at least 2 values [X, Z] or [X, Y, Z].");
        });
    }
}
