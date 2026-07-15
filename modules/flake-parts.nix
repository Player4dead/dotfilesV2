{inputs, ...}: {
  imports = [
    inputs.flake-parts.flakeModules.modules
    # inputs.wrappers.flakeModules.wrappers
  ];

  systems = [
    # systems for which you want to build the `perSystem` attributes
    "x86_64-linux"
    "aarch64-linux"
    # "x86_64-darwin"
    # "aarch64-darwin"
  ];

  perSystem = {pkgs, ...}: {
    formatter = pkgs.alejandra;
  };
}
