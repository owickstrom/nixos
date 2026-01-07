{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];
  networking.hostName = "antithesis-laptop";
  networking.hostId = "251c9149"; # TODO Required for ZFS (from 'head -c 8 /etc/machine-id').
  boot.kernelPackages = pkgs.linuxPackages;
  boot.supportedFilesystems = [ "zfs" ];
  hardware.system76.enableAll = true;
  networking.extraHosts = ''
    192.168.1.13	bhyve-host
  '';
  environment.systemPackages = with pkgs; [
    wget
    vim
    mercurial
    # direnv
    clang
    ripgrep
    fd
    kdiff3
    nixfmt-classic
    zoom-us
    zulip
  ];
}
