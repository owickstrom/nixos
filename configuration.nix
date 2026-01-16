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

  options.personal.browser = lib.mkOption {
    type = lib.types.str;
    default = "${pkgs.firefox}/bin/firefox";
    description = "Browser executable to launch with keybindings.";
  };

  options.personal.backlight.enabled = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Whether to show the backlight control in Waybar.";
  };

  options.personal.backlight.device = lib.mkOption {
    type = lib.types.str;
    default = "intel_backlight";
    #
    description = ''
      Backlight device controlled by Waybar. Find the correct one with:

          nix run 'nixpkgs#brightnessctl' -- --list
    '';
  };

  config.system.stateVersion = "25.05";
}
