{ pkgs, config, lib, linkConfig, modPath, inputs, ... }@args:
let
  mkLink = linkConfig config;
  confRoot = "${modPath.user}/emacs";

in {
  #
  # Actual config files
  #
  home.file = {
    ".emacs.d/init.el".source = mkLink.to "${confRoot}/.emacs.d/init.el";
    ".emacs.d/custom.el".source = mkLink.to "${confRoot}/.emacs.d/custom.el";
  };
}
