{ pkgs, config, lib, linkConfig, modPath, ... }: {
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      . ~/.oldbashrc
      export NIXPKGS_ALLOW_UNFREE=1
    '';
    profileExtra = ''
      export XDG_DATA_DIRS=$HOME/.nix-profile/share''${XDG_DATA_DIRS:+:}$XDG_DATA_DIRS
      if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then
          . $HOME/.nix-profile/etc/profile.d/nix.sh;
      fi
    '';
  };
}
