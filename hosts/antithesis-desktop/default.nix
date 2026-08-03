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
    clang
    ripgrep
    fd
    kdiff3
    nixfmt
    # for testing
    vscode
    slack
    docker-compose
  ];
  programs.chromium.enable = true;
  programs.chromium.extensions = [
    "aeblfdkhhhdcdjpifhhbdiojplfjncoa" # 1password
    "nngceckbapebfimnlniiiahkandclblb" # bitwarden
    "eimadpbcbfnmbkopoojfekhnkhdbieeh" # dark reader
    "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
    "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
  ];
  programs.zoom-us.enable = false;

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.production;
    powerManagement.enable = true; # fixes issues coming back from sleep
  };
  boot.kernelModules = [ "uvcvideo" ];

  personal.browser = "chromium";
  personal.backlight = {
    enabled = false;
  };

  antithesis.lock.enable = false;
  antithesis.user.global_home_manager = false;

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;

    settings = {
      adapter_name = "/dev/dri/renderD129";
      codec = "hevc";
      capture_method = "wlr";
      output_name = 1;

      # Listen precisely for the native dimensions Moonlight passes
      advertised_resolutions = "1440x1080";

      # Pad the processing frame by 4 pixels to satisfy the GPU's division limits
      canvas_width = 1440;
      canvas_height = 1080;
    };

    applications = {
      apps = [
        {
          name = "Desktop";
          # image-path = "desktop.png";
          # Automatically paths to your active desktop environment wrapper
          cmd = "${pkgs.zsh}/bin/zsh -c 'echo Streaming Desktop'";
        }
      ];
    };
  };

  # Docker
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
}
