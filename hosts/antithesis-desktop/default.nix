{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../claude-wrapper.nix
  ];
  networking.hostName = "antithesis-desktop";
  networking.hostId = "8f3893c1"; # TODO Required for ZFS (from 'head -c 8 /etc/machine-id').
  system.copySystemConfiguration = lib.mkForce false;
  boot.kernelPackages = pkgs.linuxPackages_6_18;
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
    zulip
    # for testing
    vscode
    slack
  ];
  programs.chromium.enable = true;
  programs.chromium.extensions = [
    "aeblfdkhhhdcdjpifhhbdiojplfjncoa" # 1password
    "nngceckbapebfimnlniiiahkandclblb" # bitwarden
    "eimadpbcbfnmbkopoojfekhnkhdbieeh" # dark reader
    "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
    "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
  ];
  programs.zoom-us.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.production;
    powerManagement.enable = true; # fixes issues coming back from sleep
  };

  personal.browser = "chromium";
  personal.backlight = {
    enabled = false;
  };

  antithesis.lock.enable = false;
}
