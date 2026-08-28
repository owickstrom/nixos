{
  inputs = {
    # This is pointing to an unstable release.
    # If you prefer a stable release instead, you can this to the latest number shown here: https://nixos.org/download
    # i.e. nixos-24.11
    # Use `nix flake update` to update the flake to the latest revision of the chosen release channel.
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
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
