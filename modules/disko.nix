{
  inputs,
  self,
  ...
}: {
  imports = [
    inputs.disko.flakeModules.default
  ];

  flake.modules.nixos.core = {
    imports = [
      inputs.disko.nixosModules.disko
    ];

    disko.devices = self.diskoConfigurations.server.devices;
  };

  flake.diskoConfigurations = {
    server = {
      devices = {
        disk = {
          main = {
            type = "disk";
            device = "/dev/nvme0n1";
            content = {
              type = "gpt";
              partitions = {
                ESP = {
                  size = "1G";
                  type = "EF00";
                  content = {
                    type = "filesystem";
                    format = "vfat";
                    mountpoint = "/boot";
                    mountOptions = ["umask=0077"];
                    extraArgs = [
                      "-n"
                      "NIXBOOT"
                    ];
                  };
                };
                zfs = {
                  size = "100%";
                  content = {
                    type = "zfs";
                    pool = "zroot";
                  };
                };
              };
            };
          };
        };
        zpool = {
          zroot = {
            type = "zpool";
            # mode = "mirror";
            # Workaround: cannot import 'zroot': I/O error in disko tests
            # options.cachefile = "none";
            rootFsOptions = {
              compression = "zstd";
              acltype = "posixacl";
              xattr = "sa";
              atime = "off";
              # autotrim = "on";
              # ashift = "12";

              normalization = "formD";
              dnodesize = "auto";
            };
            postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^zroot@blank$' || zfs snapshot zroot@blank";

            datasets = {
              root = {
                type = "zfs_fs";
                options.mountpoint = "legacy";
                mountpoint = "/";
              };

              nix = {
                type = "zfs_fs";
                options.mountpoint = "legacy";
                mountpoint = "/nix";
              };

              cache = {
                type = "zfs_fs";
                options.mountpoint = "legacy";
                mountpoint = "/cache";
              };

              persist = {
                type = "zfs_fs";
                options.mountpoint = "legacy";
                mountpoint = "/persist";
              };

              tmp = {
                type = "zfs_fs";
                options.mountpoint = "legacy";
                mountpoint = "/tmp";
              };
            };
          };
        };
      };
    };
  };
}
