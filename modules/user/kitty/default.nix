{ pkgs, config, lib, ... }: {
  programs.kitty = {
    enable = true;
    extraConfig = ''
      font_family JetBrainsMono Nerd Font
      bold_font auto
      bold_italic_font auto
      italic_font auto

      font_size 12

      disable_ligatures always
      map ctrl+shift+t new_tab_with_cwd
      touch_scroll_multiplier 2.0
      enable_audio_bell no
    '';
  };
}
