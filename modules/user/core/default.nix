{ config, pkgs, libs, ... }: {
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    unzip
    ripgrep
    iosevka
    pandoc
    texlive.combined.scheme-medium
    corefonts
    vistafonts
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  home.sessionVariables = { TERM = "xterm-256color"; };
}
