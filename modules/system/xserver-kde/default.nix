{ config, pkgs, ... }: {
  services.xserver.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  environment.systemPackages = with pkgs; [ kde-gtk-config ];

  networking.networkmanager.enable = true;
}
