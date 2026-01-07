{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];
  networking.hostName = "spruce";
  environment.systemPackages = with pkgs; [ ];
}
