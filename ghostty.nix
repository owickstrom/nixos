{
  config,
  lib,
  pkgs,
  ...
}:
let
  themes = pkgs.callPackage ./themes.nix { };
in
{
  home.activation.ghosttySymlinks = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD mkdir -p ~/.config/ghostty
    $DRY_RUN_CMD ln -sfn ${config.home.homeDirectory}/nixos/ghostty/config ~/.config/ghostty/config
  '';

  xdg.configFile."ghostty/themes/lancia-dark".text = ''
    palette = 0=#4f4f4f
    palette = 1=#fa6c60
    palette = 2=#a8ff60
    palette = 3=#fffeb7
    palette = 4=#96cafe
    palette = 5=#fa73fd
    palette = 6=#c6c5fe
    palette = 7=#efedef
    palette = 8=#7b7b7b
    palette = 9=#fcb6b0
    palette = 10=#cfffab
    palette = 11=#ffffcc
    palette = 12=#b5dcff
    palette = 13=#fb9cfe
    palette = 14=#e0e0fe
    palette = 15=#ffffff
    background = ${themes.dark.background}
    foreground = ${themes.dark.foreground}
    cursor-color = ${themes.dark.foreground}
    cursor-text = ${themes.dark.background}
    selection-background = ${themes.dark.background-muted}
    selection-foreground = ${themes.dark.foreground}
  '';

  xdg.configFile."ghostty/themes/lancia-light".text = ''
    palette = 0=#ffffff
    palette = 1=#a8334c
    palette = 2=#4f6c31
    palette = 3=#944927
    palette = 4=#286486
    palette = 5=#88507d
    palette = 6=#3b8992
    palette = 7=#353535
    palette = 8=#aca9a9
    palette = 9=#94253e
    palette = 10=#3f5a22
    palette = 11=#803d1c
    palette = 12=#1d5573
    palette = 13=#7b3b70
    palette = 14=#2b747c
    palette = 15=#5c5c5c
    background = ${themes.light.background}
    foreground = ${themes.light.foreground}
    cursor-color = ${themes.light.foreground}
    cursor-text = ${themes.light.background}
    selection-background = ${themes.light.background-muted}
    selection-foreground = ${themes.light.foreground}
  '';
}
