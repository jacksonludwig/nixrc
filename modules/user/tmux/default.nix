{ pkgs, config, lib, linkConfig, modPath, ... }: {
  home.packages = with pkgs; [ xsel ];
  home.file.".tmux.conf".source =
    (linkConfig config).to "${modPath.user}/tmux/.tmux.conf";
}
