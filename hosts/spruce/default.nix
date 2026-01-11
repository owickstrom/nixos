{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];
  networking.hostName = "spruce";
  time.timeZone = "Europe/Stockholm";
  environment.systemPackages = with pkgs; [ ];
  programs.firefox.enable = true;

  programs.chromium = {
    enable = true;
    package = pkgs.chromium;
    dictionaries = [
      pkgs.hunspellDictsChromium.en_US
      pkgs.hunspellDictsChromium.sv_SE
    ];
    extensions = [
      "nngceckbapebfimnlniiiahkandclblb" # bitwarden
      "eimadpbcbfnmbkopoojfekhnkhdbieeh" # dark reader
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
      "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
    ];
  };
}
