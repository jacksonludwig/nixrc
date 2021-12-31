{
  description = "System & home configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-21.11";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    telescope-fzf-native = {
      url = "github:nvim-telescope/telescope-fzf-native.nvim";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nixos-hardware
    , neovim-nightly-overlay, ... }:
    let
      # Import attrs generated from running the `init-repo.sh` script.
      meta = import ./metaInfo.nix;

      # Utility to let us symlink and un-symlink our non-nix config files on
      # demand.
      linkConfig = config: rec {
        # Set to true to have non-nix configs update as they're changed (i.e.
        # without requiring a rebuild).
        live = true;

        flakeRoot = self.outPath;
        extRoot = meta.repoDir;
        to = path:
          if live then
            config.lib.file.mkOutOfStoreSymlink "${extRoot}/${path}"
          else
            "${flakeRoot}/${path}";
      };

      # Where, relative to the root of the flake, we can access our config
      # modules.
      modPath = {
        user = "modules/user"; # For user-specific configs
        lang = "modules/user/langs"; # For programming-language-specific configs
        system = "modules/system"; # For system-wide configs
        # ^^^^ usually firmware/driver/hardware-related.
      };

      # This (./. + "path") is the only way to get nix to not complain about
      # our string paths not being absolute.
      toMod = type: name: builtins.toPath (./. + "/${modPath.${type}}/${name}");
      toMods = type: modList: map (toMod type) modList;
      uMods = modList: toMods "user" modList;
      langMods = modList: toMods "lang" modList;
      sysMods = modList: toMods "system" modList;

      # Terminal needs for every machine.
      coreModules = uMods [ "core" "dev-tools" "nvim" "tmux" "emacs" ]
        ++ langMods [ "python" "js" "c" ];

      # Currently scuffed sadsad
      telescope-fzf-native-overlay = final: prev: {
        telescope-fzf-native =
          prev.callPackage ./custom/telescope-fzf-native.nix {
            src = inputs.telescope-fzf-native;
          };
      };

      # Use tsserver from nixpkgs stable (21.11)
      typescriptOverlay = system:
        (final: prev: {
          typescript-language-server = (import inputs.nixpkgs-stable {
            inherit system;
          }).nodePackages.typescript-language-server;
        });

      neovimOverlays =
        [ neovim-nightly-overlay.overlay telescope-fzf-native-overlay ];
      langOverlays = system: [ (typescriptOverlay system) ];
      developmentOverlays = system: neovimOverlays ++ (langOverlays system);

      #
      # Defaults: change these as you'd like.
      #
      stdUser = meta.username;

      hmConfDefaults = rec {
        system = "x86_64-linux";
        stateVersion = "21.05";
        extraSpecialArgs = { inherit inputs linkConfig modPath; };
        username = meta.username;
        homeDirectory = meta.homeDir;
        configuration = {
          imports = [ ];
          nixpkgs.overlays = (developmentOverlays system);
        };
      };

      #
      # We want to actually define our configs with this function.
      #
      mkHMConf = user: attrs:
        home-manager.lib.homeManagerConfiguration (hmConfDefaults // {
          username = user;
          homeDirectory = "/home/${user}";
        } // attrs);

    in {
      homeManagerConfigurations = {
        wsl = mkHMConf stdUser rec {
          system = "x86_64-linux";
          configuration = {
            imports = coreModules ++ uMods [ "kittynonnixos" "bashnonnixos" ];
            nixpkgs.overlays = (developmentOverlays system) ++ [ ];
          };
        };

        fedora = mkHMConf stdUser rec {
          system = "x86_64-linux";
          configuration = {
            imports = coreModules ++ uMods [ "kittynonnixos" "bashnonnixos" ];
            nixpkgs.overlays = (developmentOverlays system) ++ [ ];
          };
        };

        nixos = mkHMConf stdUser rec {
          system = "x86_64-linux";
          configuration = {
            imports = coreModules ++ uMods [ "kitty" "bashnixos" ];
            nixpkgs.overlays = (developmentOverlays system) ++ [ ];
          };
        };
      };

      # System configurations
      nixosConfigurations = {
        nixosdesktop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = sysMods [
            "core"
            "efi-singledrive"
            "generic-sysuser"
            "desktop-hardware-amd-conf"
            "xserver-gnome40"
            "pipewire"
            "nvidia"
            "amd-cpu"
          ];
        };
      };

    };
}
