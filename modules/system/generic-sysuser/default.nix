{ config, pkgs, ... }: {
  users.users.jackson = {
    isNormalUser = true;
    isSystemUser = false;
    initialPassword = "password";
    extraGroups = [ "wheel" "docker" "networkmanager" "video" ];
  };
}
