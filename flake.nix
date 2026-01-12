{
  inputs = {
    # This is pointing to an unstable release.
    # If you prefer a stable release instead, you can this to the latest number shown here: https://nixos.org/download
    # i.e. nixos-24.11
    # Use `nix flake update` to update the flake to the latest revision of the chosen release channel.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ self, nixpkgs, home-manager, ... }: {

    # personal setup
    nixosConfigurations.spruce = nixpkgs.lib.nixosSystem {
      modules = [
        home-manager.nixosModules.home-manager
        ./configuration.nix
        ./hosts/antithesis-laptop
      ];
    };

    nixosConfigurations."antithesis-laptop" = nixpkgs.lib.nixosSystem {
      modules = [
        home-manager.nixosModules.home-manager
        /etc/nixos/antithesis
        ./configuration.nix
        ./hosts/antithesis-laptop
      ];
    };

    nixosConfigurations."antithesis-desktop" = nixpkgs.lib.nixosSystem {
      modules = [
        home-manager.nixosModules.home-manager
        /etc/nixos/antithesis
        ./configuration.nix
        ./hosts/antithesis-desktop
      ];
    };
  };
}
