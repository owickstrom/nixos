{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];
  networking.hostName = "spruce";
  time.timeZone = "Europe/Stockholm";
  environment.systemPackages = with pkgs; [ direnv ];
  programs.firefox.enable = true;

  programs.chromium = {
    enable = true;
    extraOpts = {
      "BrowserSignin" = 0;
      "SyncDisabled" = true;
      "PasswordManagerEnabled" = false;
      "SpellcheckEnabled" = true;
      "SpellcheckLanguage" = [
        "sv-SE"
        "en-US"
      ];
    };
    extensions = [
      "nngceckbapebfimnlniiiahkandclblb" # bitwarden
      "eimadpbcbfnmbkopoojfekhnkhdbieeh" # dark reader
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
      "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
    ];
  };
  personal.backlight = {
    enabled = true;
    device = "intel_backlight";
  };
}
