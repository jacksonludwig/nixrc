{ pkgs, config, lib, modPath, linkConfig, inputs, ... }:
let
  mkLink = linkConfig config;
  confRoot = "${modPath.user}/kitty";
in {
  programs.kitty = { enable = true; };

  xdg.configFile."kitty/kitty.conf".source = mkLink.to "${confRoot}/kitty.conf";
}
