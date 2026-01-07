{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./common.nix
  ];

  options.personal.checkout = lib.mkOption {
    type = lib.types.str;
    default = "/home/owi/projects/nixos";
    description = "The path where this repository is checked out.";
  };

  config.system.stateVersion = "25.05";
}
