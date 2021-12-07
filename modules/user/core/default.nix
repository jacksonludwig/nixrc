{ config, pkgs, libs, ... }: {
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    unzip
    ripgrep
    pandoc
    texlive.combined.scheme-medium
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    iosevka
    vistafonts
    ranger
  ];
}
