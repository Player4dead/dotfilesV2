{
  config,
  inputs,
  ...
}: let
  mkNixos = host: {
    system ? "x86_64-linux",
    isVm ? false,
    user ? "user",
    creation ? inputs.nixpkgs.lib.nixosSystem,
    extraConfig ? {},
  }:
    creation {
      inherit system;

      modules = [
        {
          config.custom.constants = rec {
            inherit host isVm user;
            isRaspi = host == "raspi";
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

    raspi = mkNixos "raspi" {
      system = "aarch64-linux";
      creation = inputs.nixos-raspberrypi.lib.nixosSystem;
    };

    # create VMs for each host configuration, build using
    # nixos-rebuild build-vm --flake .#desktop-vm
    # desktop-vm = mkVm "desktop" {};
  };
}
