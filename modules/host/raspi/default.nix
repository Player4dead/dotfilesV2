{inputs, ...} @ top: {
  flake.modules.nixos.host_raspi = {config, ...}: let
    import = with inputs.nixos-raspberrypi.nixosModules.raspberry-pi-5;
      [
        base
        display-vc4
        bluetooth
      ]
      ++ (with top.config.flake.modules.nixos; [ssh]);
  in {
    imports = import;

    networking.hostId = "89eaa833";

    system.stateVersion = "25.11";
  };
}
