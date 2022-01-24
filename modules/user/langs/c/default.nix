{ config, pkgs, libs, ... }: {
  home.packages = with pkgs; [ clang clang-tools stdenv.cc.cc.lib ];
}
