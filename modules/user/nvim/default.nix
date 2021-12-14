{ pkgs, config, lib, linkConfig, modPath, inputs, ... }@args:
let
  mkLink = linkConfig config;
  confRoot = "${modPath.user}/nvim";

  languageServers = with pkgs; [
    typescript-language-server
    nodePackages.vscode-langservers-extracted
    nodePackages.yaml-language-server
    nodePackages.pyright
    sumneko-lua-language-server
  ];

  formatters = with pkgs; [
    stylua
    nixfmt
    black
    python39Packages.isort
    nodePackages.prettier
  ];

  tools = with pkgs; [ tree-sitter fd neovim-remote ];

in {
  programs.bash = {
    bashrcExtra = ''
      export EDITOR="nvim"
    '';
  };

  home.packages = with pkgs; [ ] ++ formatters ++ languageServers ++ tools;

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    withPython3 = true;
    extraConfig = ''
      lua require('jackson')
    '';
  };

  # Install the fzf shared library
  xdg.dataFile."nvim/site/pack/packer/start/telescope-fzf-native.nvim/build/libfzf.so".source =
    "${pkgs.telescope-fzf-native}/build/libfzf.so";

  # Actual config files
  xdg.configFile = {
    "nvim/lua/jackson/init.lua".source =
      mkLink.to "${confRoot}/lua/jackson/init.lua";
    "nvim/coc/coc.vim".source = mkLink.to "${confRoot}/coc/coc.vim";
    "nvim/ftplugin/markdown.vim".source =
      mkLink.to "${confRoot}/ftplugin/markdown.vim";
    "nvim/ftplugin/help.vim".source = mkLink.to "${confRoot}/ftplugin/help.vim";
  };
}
