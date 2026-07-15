{
  inputs,
  lib,
  ...
}:
{
  flake.modules.nixos.core =
    { config, ... }:
    let
      inherit (config.custom.constants) user;
      cfg = config.custom.persist;
      assertNoHomeDirs =
        paths:
        assert (
          lib.assertMsg (
            !lib.any (p: lib.hasPrefix "/home/" (if lib.isAttrs p then p.file else p)) paths
          ) "/home used in a root persist!"
        );
        paths;
    in
    {
      imports = [
        inputs.impermanence.nixosModules.impermanence
      ];

      options.custom = {
        # passthru types.anything and let impermanence do the type checking
        persist = {
          root = {
            directories = lib.mkOption {
              type = lib.types.listOf lib.types.anything;
              default = [ ];
              apply = assertNoHomeDirs;
              description = "Directories to persist in root filesystem";
            };
            files = lib.mkOption {
              type = lib.types.listOf lib.types.anything;
              default = [ ];
              apply = assertNoHomeDirs;
              description = "Files to persist in root filesystem";
            };
            cache = {
              directories = lib.mkOption {
                type = lib.types.listOf lib.types.anything;
                default = [ ];
                apply = assertNoHomeDirs;
                description = "Directories to persist, but not to snapshot";
              };
              files = lib.mkOption {
                type = lib.types.listOf lib.types.anything;
                default = [ ];
                apply = assertNoHomeDirs;
                description = "Files to persist, but not to snapshot";
              };
            };
          };
          home = {
            directories = lib.mkOption {
              type = lib.types.listOf lib.types.anything;
              default = [ ];
              description = "Directories to persist in home directory";
            };
            files = lib.mkOption {
              type = lib.types.listOf lib.types.anything;
              default = [ ];
              description = "Files to persist in home directory";
            };
            cache = {
              directories = lib.mkOption {
                type = lib.types.listOf lib.types.anything;
                default = [ ];
                description = "Directories to persist, but not to snapshot";
              };
              files = lib.mkOption {
                type = lib.types.listOf lib.types.anything;
                default = [ ];
                description = "Files to persist, but not to snapshot";
              };
            };
          };
        };
      };

      config = {
        # root and home on tmpfs
        # fileSystems."/" = lib.mkForce {
        #   device = "tmpfs";
        #   fsType = "tmpfs";
        #   options = [
        #     "defaults"
        #     # whatever size feels comfortable, smaller is better
        #     # a good default is to start with 1G, having a small tmpfs acts as a tripwire hinting that there is something
        #     # you should probably persist, but haven't done so
        #     # "size=1G"
        #     "size=256M"
        #     "mode=755"
        #   ];
        # };

        # shut sudo up
        security.sudo.extraConfig = "Defaults lecture=never";

        # setup persistence
        environment.persistence = {
          "/persist" = {
            enable = true;
            hideMounts = true;
            directories =
              cfg.root.directories ++ map (directorie: "/home/${user}/${directorie}") cfg.home.directories;
            files = lib.unique (cfg.root.files ++ map (file: "/home/${user}/${file}") cfg.home.files);
          };
          "/cache" = {
            enable = true;
            hideMounts = true;
            directories = lib.unique (
              [
                "/var/log"
                "/var/lib/nixos"
              ]
              ++ cfg.root.cache.directories
              ++ map (directorie: "/home/${user}/${directorie}") cfg.home.cache.directories
            );

            files = lib.unique (
              cfg.root.cache.files ++ map (file: "/home/${user}/${file}") cfg.home.cache.files
            );
          };
        };
      };
    };
}
