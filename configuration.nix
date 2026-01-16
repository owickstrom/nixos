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

  config.system.stateVersion = "25.05";
}
