{
  description = "NixOS and nix-darwin configs for my machines";
  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixOS profiles to optimize settings for different hardware
    hardware.url = "github:nixos/nixos-hardware";

    # Global catppuccin theme
    catppuccin.url = "github:catppuccin/nix";

    # NixOS Spicetify
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix Darwin (for MacOS machines)
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Homebrew
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = { self, catppuccin, darwin, home-manager, nix-homebrew, nixpkgs, ...
    }@inputs:
    let
      inherit (self) outputs;

      # Define user configurations
      users = {
        damo = {
          avatar = ./files/avatar/face;
          email = "damon.oehlman@gmail.com";
          fullName = "Damon Oehlman";
          gitKey = "C339367066473070";
          gpgSshKey = "DB11504F72933C09A0DAE61E152030B26D2A9973";
          name = "damo";
        };
      };

      # Function for NixOS system configuration
      mkNixosConfiguration = hostname: username:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs hostname;
            userConfig = users.${username};
          };
          modules = [ ./hosts/${hostname}/configuration.nix ];
        };

      # Function for nix-darwin system configuration
      mkDarwinConfiguration = hostname: username:
        darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = {
            inherit inputs outputs hostname;
            userConfig = users.${username};
          };
          modules = [
            ./hosts/modules/common.nix
            ./hosts/modules/common-darwin.nix
            ./hosts/darwin/${hostname}/configuration.nix
            home-manager.darwinModules.home-manager
            nix-homebrew.darwinModules.nix-homebrew
          ];
        };

      # Function for Home Manager configuration
      mkHomeConfiguration = { system ? "x86_64-linux", username, hostname
        , homeDirectory ? "/home/${username}", }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system; };
          extraSpecialArgs = {
            inherit inputs outputs;
            userConfig = users.${username};
            homeDirectory = homeDirectory;
          };
          modules = [
            ./home/${username}/${hostname}.nix
            catppuccin.homeModules.catppuccin
          ];
        };
    in {
      nixosConfigurations = {
        energy = mkNixosConfiguration "energy" "nabokikh";
        nabokikh-z13 = mkNixosConfiguration "nabokikh-z13" "nabokikh";
        djo-steamdeck = mkNixosConfiguration "djo-steamdeck" "damo";
        djo-x270 = mkNixosConfiguration "djo-x270" "damo";
      };

      darwinConfigurations = {
        "defrag-mini" = mkDarwinConfiguration "defrag-mini" "damo";
        "defrag-air" = mkDarwinConfiguration "defrag-air" "damo";
        "djo-affectable" = mkDarwinConfiguration "djo-affectable" "damo";
      };

      homeConfigurations = {
        # "nabokikh@energy" = mkHomeConfiguration { system = "x86_64-linux"; username = "nabokikh";  hostname = "energy"; };
        # "nabokikh@nabokikh-mac" = mkHomeConfiguration "aarch64-darwin" "nabokikh" "nabokikh-mac";
        # "nabokikh@nabokikh-z13" = mkHomeConfiguration "x86_64-linux" "nabokikh" "nabokikh-z13";
        "damo@defrag-mini" = mkHomeConfiguration {
          system = "aarch64-darwin";
          username = "damo";
          hostname = "defrag-mini";
          homeDirectory = "/Volumes/user-damo";
        };
        "damo@defrag-air" = mkHomeConfiguration {
          system = "aarch64-darwin";
          username = "damo";
          hostname = "defrag-air";
          homeDirectory = "/Users/damo";
        };
        "damo@djo-affectable" = mkHomeConfiguration {
          system = "aarch64-darwin";
          username = "damo";
          hostname = "djo-affectable";
          homeDirectory = "/Users/damo";
        };

        "damo@djo-steamdeck" = mkHomeConfiguration {
          username = "damo";
          hostname = "djo-steamdeck";
        };

        "damo@djo-x270" = mkHomeConfiguration {
          username = "damo";
          hostname = "djo-x270";
        };
      };

      overlays = import ./overlays { inherit inputs; };
    };
}
