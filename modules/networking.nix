{

  flake.modules.nixos.core = {
    networking.networkmanager.enable = true;
    services.tailscale.enable = true;
  };
}
