{ config, pkgs, libs, ... }: {
  programs.bash = {
    bashrcExtra = ''
      alias lg="lazygit"
      alias pandoc="pandoc --pdf-engine=lualatex"

      # Create a new worktree with branch name $1 and path $2 based off of branch name $3
      gwa() {
        git worktree add -b "$1" "$2" "$3"
      }
    '';
  };

  home.packages = with pkgs; [ lazygit awscli2 ];
}
