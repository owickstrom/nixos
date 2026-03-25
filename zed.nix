{
  config,
  lib,
  pkgs,
  ...
}:
{
  xdg.configFile."zed/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/zed/settings.json";
  xdg.configFile."zed/keymap.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/zed/keymap.json";
}
