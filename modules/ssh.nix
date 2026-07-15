{
  flake.modules.nixos.ssh = {config, ...}: let
    inherit (config.custom.constants) user;
  in {
    services.openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        PasswordAuthentication = true;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
        AllowUsers = ["${user}"];
        MaxAuthTries = 3;
        # PerSourcePenalties = "crash:3600s authfail:3600s max:86400s";
      };
    };

    custom.persist.home.cache.directories = [".ssh"];
  };
}
