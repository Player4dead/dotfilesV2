{inputs, ...}: {
  flake.modulesmodules.nixos = {pkgs, ...}: {
    imports = [inputs.nvf.nixosModules.nvf];
    environment.systemPackages = with pkgs; [nixd];
    programs.nvf = {
      enable = true;
      settings.vim = {
        autocomplete.nvim-cmp.enable = true;
        lsp.enable = true;

        languages = {
          enableFormat = true;
          nix = {
            enable = true;
            extraDiagnostics.enable = true;
            lsp.enable = true;

            format = {
              enable = true;
              type = ["nixfmt"];
            };
          };
          rust = {
            enable = true;
            lsp.enable = true;
            format.enable = true;
          };

          bash = {
            enable = true;
            extraDiagnostics.enable = true;
            lsp.enable = true;
            format.enable = true;
          };
        };
        lsp = {
          formatOnSave = true;
        };
      };
    };
    # set nvim to default text editor
    environment.variables.EDITOR = "nvim";
  };
}
