{ pkgs, config, lib, linkConfig, modPath, inputs, ... }@args:
let
  php = pkgs.php80;
  psysh = pkgs.php80Packages.psysh;
  mkLink = linkConfig config;
in {
  home.packages = [ php psysh ];

  #
  # Link .ini files
  #
  xdg.configFile."psysh/config.php".source =
    mkLink.to "${modPath.user}/langs/php/psysh/config.php";
}