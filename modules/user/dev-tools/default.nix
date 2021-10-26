{ config, pkgs, libs, ... }: {
  programs.bash = {
    bashrcExtra = ''
      alias lg="lazygit"
      alias pandoc="pandoc --pdf-engine=lualatex"
    '';
  };

  home.packages = with pkgs; [ lazygit gcc ];
}
