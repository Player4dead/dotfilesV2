{
  inputs,
  config,
  ...
}: {
  flake.deploy.nodes.server = {
    hostname = "nixos.tail077190.ts.net";
    profiles.system = {
      user = "user";
      path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos config.flake.nixosConfigurations.server;
    };
  };

  perSystem = {system, ...}: {
    checks =
      inputs.deploy-rs.lib.${system}.deployChecks config.flake.deploy;
  };

  # perSystem = {system, ...}: {
  #   checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks config.flake.deploy) inputs.deploy-rs.lib;
  # };
}
