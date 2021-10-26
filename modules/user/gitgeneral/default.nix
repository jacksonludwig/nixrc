{ pkgs, config, lib, ...}:
{
  programs.git = {
    enable = true;
    userName  = "jacksonludwig";
    userEmail = "jacksonludwig0@gmail.com";
  };
}
