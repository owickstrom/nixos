{ config, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];
  networking.hostName = "antithesis-desktop";
  networking.hostId = "8f3893c1"; # TODO Required for ZFS (from 'head -c 8 /etc/machine-id').
  boot.kernelPackages = pkgs.linuxPackages;
  boot.supportedFilesystems = [ "zfs" ];
  hardware.system76.enableAll = true;
  networking.extraHosts = ''
    192.168.1.13	bhyve-host
  '';
  time.timeZone = "Europe/Stockholm";
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
  programs.chromium.enable = true;
  programs.chromium.extensions = [
    "aeblfdkhhhdcdjpifhhbdiojplfjncoa" # 1password
    "nngceckbapebfimnlniiiahkandclblb" # bitwarden
    "eimadpbcbfnmbkopoojfekhnkhdbieeh" # dark reader
    "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
    "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
  ];

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.production;
    powerManagement.enable = true; # fixes issues coming back from sleep
  };
}
