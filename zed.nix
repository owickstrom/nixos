{
  config,
  lib,
  pkgs,
  ...
}:
{

  home.packages = with pkgs; [
    zed-editor
  ];

  home.activation.zedSymlinks = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD mkdir -p ~/.config/zed
    $DRY_RUN_CMD ln -sfn ${config.home.homeDirectory}/nixos/zed/settings.json ~/.config/zed/settings.json
    $DRY_RUN_CMD ln -sfn ${config.home.homeDirectory}/nixos/zed/keymap.json ~/.config/zed/keymap.json
  '';
}
