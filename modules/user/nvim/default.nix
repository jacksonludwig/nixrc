{ pkgs, config, lib, linkConfig, modPath, inputs, ... }@args:
let
  mkLink = linkConfig config;
  ts = pkgs.tree-sitter.builtGrammars;
  confRoot = "${modPath.user}/nvim";

  languageServers = with pkgs; [
    typescript-language-server
    nodePackages.vscode-langservers-extracted
    nodePackages.prettier
    nodePackages.yaml-language-server
    nodePackages.pyright
    sumneko-lua-language-server
  ];

  formatters = with pkgs; [
    tree-sitter
    stylua
    nixfmt
    black
    python39Packages.isort
    fd
    neovim-remote
  ];

  # (xdg.configFile's)
  treesitterParsers = {
    # "nvim/parser/c.so".source = "${ts.tree-sitter-c}/parser";
    # "nvim/parser/lua.so".source = "${ts.tree-sitter-lua}/parser";
    # "nvim/parser/rust.so".source = "${ts.tree-sitter-rust}/parser";
    # "nvim/parser/python.so".source = "${ts.tree-sitter-python}/parser";
    # "nvim/parser/typescript.so".source = "${ts.tree-sitter-typescript}/parser";
    # "nvim/parser/javascript.so".source = "${ts.tree-sitter-javascript}/parser";
    # "nvim/parser/tsx.so".source = "${ts.tree-sitter-tsx}/parser";
    # "nvim/parser/nix.so".source = "${ts.tree-sitter-nix}/parser";
    # "nvim/parser/yaml.so".source = "${ts.tree-sitter-yaml}/parser";
    # "nvim/parser/bash.so".source = "${ts.tree-sitter-bash}/parser";
    # "nvim/parser/comment.so".source = "${ts.tree-sitter-comment}/parser";
  };

in {
  programs.bash = {
    bashrcExtra = ''
      export EDITOR="nvim"
    '';
  };

  home.packages = with pkgs; [ ] ++ formatters ++ languageServers;

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

  # Do the requisite black magic for telescope-fzf
  xdg.dataFile."nvim/site/pack/packer/start/telescope-fzf-native.nvim/build/libfzf.so".source =
    "${pkgs.telescope-fzf-native}/build/libfzf.so";

  #
  # Actual config files
  #
  xdg.configFile = {
    "nvim/lua/jackson/init.lua".source = mkLink.to "${confRoot}/lua/jackson/init.lua";
    "nvim/coc/coc.vim".source = mkLink.to "${confRoot}/coc/coc.vim";
    "nvim/ftplugin/markdown.vim".source =
      mkLink.to "${confRoot}/ftplugin/markdown.vim";
  } // treesitterParsers;
}
