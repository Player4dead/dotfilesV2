{lib, ...}: {
  flake.modules.nixos.core = {config, ...}: let
    inherit (config.custom.constants) isRaspi;
  in
    lib.mkMerge [
      (lib.mkIf isRaspi {
        system.nixos.tags = let
          cfg = config.boot.loader.raspberry-pi;
        in [
          "raspberry-pi-${cfg.variant}"
          cfg.bootloader
          config.boot.kernelPackages.kernel.version
        ];
      })

      (lib.mkIf (!isRaspi) {
        boot.loader = {
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
        };
      })
    ];
}
