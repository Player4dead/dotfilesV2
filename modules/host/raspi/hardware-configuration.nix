{
  flake.modules.nixos.host_raspi =
    {
      config,
      lib,
      pkgs,
      modulePath,
      ...
    }:
    {
      # imports = [
      #   (modulePath + "/installer/scan/not-detected.nix")
      # ];

      boot = {
        supportedFilesystems = [ "zfs" ];
        kernelModules = [ ];
        extraModulePackages = [ ];
        initrd = {
          availableKernelModules = [ ];
          kernelModules = [ ];
        };
      };

      nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
    };
}
