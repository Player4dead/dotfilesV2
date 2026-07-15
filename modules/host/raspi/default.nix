{inputs, ...} @ top: {
  flake.modules.nixos.host_raspi = {config, ...}: let
    import = with inputs.nixos-raspberrypi.nixosModules.raspberry-pi-5;
      [
        base
        display-vc4
        bluetooth
      ]
      ++ (with top.config.flake.modules.nixos; [ssh]);
  in {
    imports = import;

    networking.hostId = "89eaa833";

    zramSwap = {
      enable = true;
      memoryPercent = 100;
    };

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
    nix.optimise = {
      automatic = true;
      dates = ["03:45"];
    };

    security.sudo.wheelNeedsPassword = false;

    system.stateVersion = "25.11";
  };
}
