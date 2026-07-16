{
  flake.modules.nixos.core = {
    networking.networkmanager.enable = true;

    custom.persist.root.cache.directories = ["/var/lib/NetworkManager"];

    services.tailscale.enable = true;
  };
}
