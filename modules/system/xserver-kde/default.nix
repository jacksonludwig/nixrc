{ config, pkgs, ... }:
{
  services.xserver.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  networking.networkmanager.enable = true;
}
