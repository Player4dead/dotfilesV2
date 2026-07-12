{
  flake.modules.nixos.core = {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;

      histSize = 10000;
      histFile = "$HOME/.zsh_history";
      setOptions = [
        "HIST_IGNORE_ALL_DUPS"
      ];

      ohMyZsh = {
        enable = true;
        plugins = [
          "z"
          "extract"
          "sudo"
        ];
        theme = "kardan";
      };
    };

    # custom.persist.home.cache.files = [".zsh_history"];
  };
}
