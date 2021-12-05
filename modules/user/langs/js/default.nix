{ config, pkgs, libs, ... }: {
  home.packages = with pkgs; [ nodejs-16_x ];

  programs.bash = {
    bashrcExtra = ''
      export PATH=$PATH:~/.npm/bin
    '';
  };
}
