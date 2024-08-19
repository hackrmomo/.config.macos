{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      environment.variables = {
        ZDOTDIR = "$HOME/.config/zsh";
      };

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [
          pkgs.vim
          pkgs.vscode
          pkgs.raycast
          pkgs.spotify
          pkgs.mos
          pkgs.alacritty
          pkgs.discord
          pkgs.slack
          pkgs.teams
          pkgs.kitty
          pkgs.starship
          pkgs.dotnet-sdk_8
          pkgs.azure-cli
          pkgs.stats
          pkgs.poetry
          pkgs.python313Full
          pkgs.lazygit
        ];
      nixpkgs.config = { allowBroken = true; allowUnfree = true; };

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh = {
        enable = true;
      };
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      fonts.packages = with pkgs; [
        (nerdfonts.override { fonts = [ 
          "FiraCode" 
          "DroidSansMono" 
          "0xProto" 
        ];}) 
        (google-fonts.override { fonts = [ 
          "DM Sans" 
          "DM Mono" 
          "DM Serif Display" 
          "DM Sans Display"
          "Cairo"
          "Zain"
        ];})
      ];

      # Enable TouchId to authenticate sudo
      security.pam.enableSudoTouchIdAuth = true;

      homebrew = {
        enable = true;
        brews = [
          
        ];

        casks = [
          "proton-pass"
          "proton-mail"
          "protonvpn"
          "proton-drive"
          "nikitabobko/tap/aerospace"
          "arc"
          "1password"
          "docker"
          "microsoft-outlook"
          "sip"
        ];
      };

      system.defaults = {
        ".GlobalPreferences"."com.apple.mouse.scaling" = -1.0;
        finder = {
          AppleShowAllExtensions = true;
          ShowPathbar = true;
          CreateDesktop = false;
        };
        dock = {
          show-recents = false;
          static-only = true;
          autohide = true;
        };
        WindowManager.StandardHideDesktopIcons = true;
      };
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Mohammads-MacBook-Pro
    darwinConfigurations."Mohammads-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."Mohammads-MacBook-Pro".pkgs;
  };
}
