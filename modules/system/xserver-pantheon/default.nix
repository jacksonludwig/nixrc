{ config, pkgs, ... }:
{
  services.xserver.enable = true;
  services.xserver.desktopManager.pantheon.enable = true;
  services.pantheon.apps.enable = true;

  services.xserver.desktopManager.pantheon.extraSwitchboardPlugs = [
    pkgs.pantheon-tweaks
  ];

  sound.enable = true;
  hardware.pulseaudio.enable = true;
}
