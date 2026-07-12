{lib, ...}: {
  flake.modules.nixos.core = {config, ...}: let
    inherit (config.custom.constants) isRaspi;
  in
    lib.mkMerge [
      (lib.mkIf isRaspi {
        boot.loader.raspberry-pi = {
          enable = true;
          variant = "5";
          bootloader = lib.mkForce "kernel";
        };
      })

      (lib.mkIf (!isRaspi) {
        boot.loader = {
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
        };
      })
    ];
}
