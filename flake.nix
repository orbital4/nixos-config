{
  description = "NixOS System Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    talon = {
      url = "github:nix-community/talon-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixvim, home-manager, talon, ... }@inputs:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
        config.allowUnfree = true;
    };
  in {
    nixosConfigurations.acer = nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        ./hosts/acer/configuration.nix

        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            inherit pkgs nixvim;
          };
          home-manager.users.al = import ./hosts/acer/home.nix;
        }
      ];
    };

    nixosConfigurations.avell = nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        ./hosts/avell/configuration.nix
        talon.nixosModules.talon

        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            inherit pkgs nixvim;
          };
          home-manager.users.al = import ./hosts/avell/home.nix;
        }
      ];
    };
  };
}
