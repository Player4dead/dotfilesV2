{
  flake.modules.nixos.host_server = {
    config,
    lib,
    pkgs,
    modulesPath,
    ...
  }: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

    boot = {
      supportedFilesystems = ["zfs"];
      kernelModules = ["kvm-amd"];
      extraModulePackages = [];
      initrd = {
        availableKernelModules = ["nvme" "xhci_pci" "usb_storage" "sd_mod"];
        kernelModules = [];
      };
    };

    swapDevices = [];

    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
