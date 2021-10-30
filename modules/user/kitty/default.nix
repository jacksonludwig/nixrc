{ pkgs, config, lib, ... }: {
  programs.kitty = {
    enable = true;
    extraConfig = ''
      font_family JetBrainsMono Nerd Font
      # font_family Iosevka
      bold_font auto
      bold_italic_font auto
      italic_font auto

      font_size 12

      disable_ligatures always
      map ctrl+shift+t new_tab_with_cwd
      touch_scroll_multiplier 2.0
      enable_audio_bell no

      enabled_layouts splits

      map F5 launch --location=hsplit --cwd=current
      map F6 launch --location=vsplit --cwd=current
      map F7 layout_action rotate

      map shift+up move_window up
      map shift+left move_window left
      map shift+right move_window right
      map shift+down move_window down

      map ctrl+left neighboring_window left
      map ctrl+right neighboring_window right
      map ctrl+up neighboring_window up
      map ctrl+down neighboring_window down
    '';
  };
}
