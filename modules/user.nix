{lib, ...}: {
  flake.modules.nixos.core = {
    config,
    pkgs,
    ...
  }: let
    inherit (config.custom.constants) user;
  in {
    # silence warning about setting multiple user password options
    # https://github.com/NixOS/nixpkgs/pull/287506#issuecomment-1950958990
    options = {
      warnings = lib.mkOption {
        apply = lib.filter (
          w: !(lib.hasInfix "If multiple of these password options are set at the same time" w)
        );
      };
    };

    config = lib.mkMerge [
      {
        users = {
          mutableUsers = false;
          # create a password with for root and $user with:
          # read -s -p "" PASSWORD && mkpasswd -m sha-512 "$PASSWORD" | sudo tee /persist/etc/shadow/root
          users = {
            root = {
              initialPassword = "passwd";
              # hashedPasswordFile = "/persist/etc/shadow/root";
            };
            ${user} = {
              isNormalUser = true;
              initialPassword = "passwd";
              # hashedPasswordFile = "/persist/etc/shadow/${user}";
              shell = pkgs.zsh;
              extraGroups = [
                "networkmanager"
                "wheel"
              ];
            };
          };
        };
      }

      # use sops for user passwords if enabled
      # {
      #   # https://github.com/Mic92/sops-nix?tab=readme-ov-file#setting-a-users-password
      #   sops.secrets = {
      #     rp.neededForUsers = true;
      #     up.neededForUsers = true;
      #   };
      #
      #   # create a password with for root and $user with:
      #   # mkpasswd -m sha-512 'PASSWORD' and place in secrets.json under the appropriate key
      #   users.users = {
      #     root.hashedPasswordFile = lib.mkForce config.sops.secrets.rp.path;
      #     ${user}.hashedPasswordFile = lib.mkForce config.sops.secrets.up.path;
      #   };
      # }
    ];
  };
}
