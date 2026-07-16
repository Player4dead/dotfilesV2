{inputs, ...} @ top: {
  flake.modules.nixos.host_server = {config, ...}: {
    imports = with top.config.flake.modules.nixos; [ssh];

    networking.hostId = "deadbeef";

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
