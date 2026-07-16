{
  flake.modules.nixos.core = {pkgs, ...}: {
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    time.timeZone = "Europe/Zurich";

    # boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_stable;

    i18n.defaultLocale = "de_CH.UTF-8";
    console.keyMap = "sg";

    boot.tmp.cleanOnBoot = true;
  };
}
