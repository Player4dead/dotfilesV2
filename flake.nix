{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wrapper-modules = {
      url = "github:BirdeeHub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    preservation.url = "github:nix-community/preservation";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    disko.url = "github:nix-community/disko";

    deploy-rs.url = "github:serokell/deploy-rs";
  };

  outputs = inputs @ {flake-parts, ...}: let
    inherit (inputs.nixpkgs.lib.fileset) toList fileFilter;
    import-tree = path:
      toList (fileFilter (file: file.hasExt "nix" && !(inputs.nixpkgs.lib.hasPrefix "_" file.name)) path);
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = import-tree ./modules;
    };
}
