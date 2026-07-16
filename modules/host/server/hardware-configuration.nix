{
  flake.modules.nixos.host_raspi = {
    config,
    lib,
    pkgs,
    modulePath,
    ...
  }: {
    # imports = [
    #   (modulePath + "/installer/scan/not-detected.nix")
    # ];

    boot = {
      supportedFilesystems = ["zfs"];
      kernelModules = [];
      extraModulePackages = [];
      initrd = {
        availableKernelModules = ["nvme" "xhci_pci" "ums_realtek" "usb_storage" "sd_mod"];
        kernelModules = [];
      };
    };
  };
}
