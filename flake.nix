{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      catppuccin,
      ...
    }:
    {

      # personal setup
      nixosConfigurations.spruce = nixpkgs.lib.nixosSystem {
        modules = [
          home-manager.nixosModules.home-manager
          catppuccin.nixosModules.catppuccin
          ./configuration.nix
          ./hosts/spruce
        ];
      };

      nixosConfigurations."antithesis-laptop" = nixpkgs.lib.nixosSystem {
        modules = [
          home-manager.nixosModules.home-manager
          catppuccin.nixosModules.catppuccin
          /etc/nixos/antithesis
          ./configuration.nix
          ./hosts/antithesis-laptop
        ];
      };

      nixosConfigurations."antithesis-desktop" = nixpkgs.lib.nixosSystem {
        modules = [
          home-manager.nixosModules.home-manager
          catppuccin.nixosModules.catppuccin
          /etc/nixos/antithesis
          ./configuration.nix
          ./hosts/antithesis-desktop
        ];
      };
    };
}
