{lib, ...}: {
  flake.modules.nixos.core = {
    config,
    pkgs,
    ...
  }:
  # let
  # inherit (config.custom.constants) isRaspi;
  # in
  {
    # lib.mkMerge = [
    #   (lib.mkIf (!isRaspi) {
    #     boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
    #   })

    # {
    boot.zfs = {
      forceImportRoot = false;
      devNodes = "/dev/disk/by-partuuid";
      extraPools = ["zroot"];
    };

    services.zfs = {
      autoScrub.enable = true;
      trim.enable = true;
    };

    fileSystems = {
      "/" = {
        #       CHANGE ME LATER
        device = "zroot/root";
        fsType = "zfs";
        neededForBoot = true;
      };

      "/boot" = {
        device = "/dev/disk/by-label/NIXBOOT";
        fsType = "vfat";
        neededForBoot = true;
      };
      "/nix" = {
        device = "zroot/nix";
        fsType = "zfs";
        neededForBoot = true;
      };

      "/cache" = {
        device = "zroot/cache";
        fsType = "zfs";
        neededForBoot = true;
      };

      "/persist" = {
        device = "zroot/persist";
        fsType = "zfs";
        neededForBoot = true;
      };

      "/tmp" = {
        device = "zroot/tmp";
        fsType = "zfs";
        neededForBoot = true;
      };
    };
    # }
    # {
    services.sanoid = {
      enable = true;

      datasets = {
        "zroot/persist" = {
          hourly = 24;
          daily = 7;
          weekly = 7;
          monthly = 20;
          yearly = 4;
        };
      };
    };
    # }
    # ];
  };
}
