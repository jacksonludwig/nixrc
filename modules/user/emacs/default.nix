{ pkgs, config, lib, linkConfig, modPath, inputs, ... }@args:
let
  mkLink = linkConfig config;
  confRoot = "${modPath.user}/emacs";

in {
  # Actual config files
  home.file = {
    ".doom.d/init.el".source = mkLink.to "${confRoot}/.doom.d/init.el";
    ".doom.d/config.el".source = mkLink.to "${confRoot}/.doom.d/config.el";
    ".doom.d/packages.el".source = mkLink.to "${confRoot}/.doom.d/packages.el";
  };
}
