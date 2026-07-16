{
  config,
  inputs,
  ...
}: let
  mkNixos = host: {
    system ? "x86_64-linux",
    isVm ? false,
    user ? "user",
    extraConfig ? {},
  }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        {
          config.custom.constants = {
            inherit host isVm user;
          };
        }
        config.flake.modules.nixos."host_${host}"
        config.flake.modules.nixos.core
        inputs.sops-nix.nixosModules.sops
        extraConfig
      ];
    };
  mkVm = host: mkNixosArgs: mkNixos host (mkNixosArgs // {isVm = true;});
in {
  flake.nixosConfigurations = {
    # desktop = mkNixos "desktop" {};

    server = mkNixos "server" {};

    # create VMs for each host configuration, build using
    # nixos-rebuild build-vm --flake .#desktop-vm
    # desktop-vm = mkVm "desktop" {};
  };
}
