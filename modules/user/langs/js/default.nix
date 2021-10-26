{ config, pkgs, libs, ... }: {
  home.packages = with pkgs; [ nodejs ];

  programs.bash = {
    bashrcExtra = ''
      export PATH=$PATH:~/.npm/bin
    '';
  };
}
