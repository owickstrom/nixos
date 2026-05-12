{ pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../claude-wrapper.nix
  ];
  networking.hostName = "antithesis-laptop";
  networking.hostId = "251c9149"; # TODO Required for ZFS (from 'head -c 8 /etc/machine-id').
  system.copySystemConfiguration = lib.mkForce false;
  boot.kernelPackages = pkgs.linuxPackages_6_18;
  boot.loader.systemd-boot.configurationLimit = 16;
  boot.supportedFilesystems = [ "zfs" ];
  networking.extraHosts = ''
    192.168.1.13	bhyve-host
  '';
  time.timeZone = "Europe/Stockholm";
  # time.timeZone = "US/Eastern";
  environment.systemPackages = with pkgs; [
    wget
    vim
    clang
    ripgrep
    fd
    kdiff3
    nixfmt
    vscode
  ];
  programs.chromium.enable = true;
  programs.chromium.extensions = [
    "aeblfdkhhhdcdjpifhhbdiojplfjncoa" # 1password
    "nngceckbapebfimnlniiiahkandclblb" # bitwarden
    "eimadpbcbfnmbkopoojfekhnkhdbieeh" # dark reader
    "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
    "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
    "eakpippijmmohmdlpgcjnipolcgciaga" # pangram
  ];
  programs.zoom-us.enable = true;
  personal.browser = "chromium";
  personal.backlight = {
    enabled = true;
    device = "acpi_video0";
  };

  antithesis.lock.enable = false;
  antithesis.user.global_home_manager = false;
}
