{
  inputs,
  lib,
  ...
}: {
  flake.modules.nixos.core = {config, ...}: let
    inherit (config.custom.constants) host user;
    cfg = config.custom.persist;
    assertNoHomeDirs = paths:
      assert (
        lib.assertMsg (!lib.any (p:
          lib.hasPrefix "/home/" (
            if lib.isAttrs p
            then p.file
            else p
          ))
        paths) "/home used in a root persist!"
      ); paths;
  in {
    imports = [
      inputs.preservation.nixosModules.default
    ];

    options.custom = {
      # passthru types.anything and let impermanence do the type checking
      persist = {
        root = {
          directories = lib.mkOption {
            type = lib.types.listOf lib.types.anything;
            default = [];
            apply = assertNoHomeDirs;
            description = "Directories to persist in root filesystem";
          };
          files = lib.mkOption {
            type = lib.types.listOf lib.types.anything;
            default = [];
            apply = assertNoHomeDirs;
            description = "Files to persist in root filesystem";
          };
          cache = {
            directories = lib.mkOption {
              type = lib.types.listOf lib.types.anything;
              default = [];
              apply = assertNoHomeDirs;
              description = "Directories to persist, but not to snapshot";
            };
            files = lib.mkOption {
              type = lib.types.listOf lib.types.anything;
              default = [];
              apply = assertNoHomeDirs;
              description = "Files to persist, but not to snapshot";
            };
          };
        };
        home = {
          directories = lib.mkOption {
            type = lib.types.listOf lib.types.anything;
            default = [];
            description = "Directories to persist in home directory";
          };
          files = lib.mkOption {
            type = lib.types.listOf lib.types.anything;
            default = [];
            description = "Files to persist in home directory";
          };
          cache = {
            directories = lib.mkOption {
              type = lib.types.listOf lib.types.anything;
              default = [];
              description = "Directories to persist, but not to snapshot";
            };
            files = lib.mkOption {
              type = lib.types.listOf lib.types.anything;
              default = [];
              description = "Files to persist, but not to snapshot";
            };
          };
        };
      };
    };

    config = {
      # root and home on tmpfs
      fileSystems."/" = lib.mkForce {
        device = "tmpfs";
        fsType = "tmpfs";
        options = [
          "defaults"
          # whatever size feels comfortable, smaller is better
          # a good default is to start with 1G, having a small tmpfs acts as a tripwire hinting that there is something
          # you should probably persist, but haven't done so
          # "size=1G"
          "size=256M"
          "mode=755"
        ];
      };

      # shut sudo up
      security.sudo.extraConfig = "Defaults lecture=never";

      # setup persistence
      preservation = {
        enable = true;

        preserveAt = {
          "/persist" = {
            commonMountOptions = ["x-gvfs-hide"];
            files = lib.unique cfg.root.files;
            directories = lib.unique (
              [
                "/var/log" # systemd journal is stored in /var/log/journal
                "/var/lib/nixos" # for persisting user uids and gids
              ]
              ++ cfg.root.directories
            );

            users.${user} = {
              files = lib.unique cfg.home.files;
              directories = lib.unique (
                [
                  # "Desktop"
                  # "Documents"
                  # "Pictures"
                  "Projekts"
                ]
                ++ lib.optionals (host != "desktop") [
                  "Downloads"
                ]
                ++ cfg.home.directories
              );
            };
          };

          # cache are files that should be persisted, but not to snapshot
          # e.g. npm, cargo cache etc, that could always be redownloaded
          "/cache" = {
            commonMountOptions = ["x-gvfs-hide"];
            files = lib.unique cfg.root.cache.files;
            directories = ["/var/lib/systemd/coredump"] ++ lib.unique cfg.root.cache.directories;

            users.${user} = {
              files = lib.unique cfg.home.cache.files;
              directories = lib.unique cfg.home.cache.directories;
            };
          };
        };
      };
    };
  };
}
