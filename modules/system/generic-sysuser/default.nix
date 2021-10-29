{ config, pkgs, ... }:
{
  users.users.generic = {
    isNormalUser = true;
    isSystemUser = false;
    initialPassword = "password";
    extraGroups = [ "wheel" "docker" "networkmanager" "video" ];
  };
}
