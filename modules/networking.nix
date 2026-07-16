{
  flake.modules.nixos.core = {
    networking.networkmanager.enable = true;

    services.tailscale.enable = true;

    custom.persist.root.cache.directories = [
      "/var/lib/NetworkManager"
      "/var/cache/tailscale"
      "/var/lib/tailscale"
    ];
  };
}
