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
  xdg.configFile."ghostty/config".source = config.lib.file.mkOutOfStoreSymlink ./ghostty/config;

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
    palette = 0=#000000
    palette = 1=#bb0000
    palette = 2=#00bb00
    palette = 3=#bbbb00
    palette = 4=#0000bb
    palette = 5=#bb00bb
    palette = 6=#00bbbb
    palette = 7=#bbbbbb
    palette = 8=#555555
    palette = 9=#ff5555
    palette = 10=#2fd92f
    palette = 11=#bfbf15
    palette = 12=#5555ff
    palette = 13=#ff55ff
    palette = 14=#22cccc
    palette = 15=#ffffff
    background = ${themes.light.background}
    foreground = ${themes.light.foreground}
    cursor-color = ${themes.light.foreground}
    cursor-text = ${themes.light.background}
    selection-background = ${themes.light.background-muted}
    selection-foreground = ${themes.light.foreground}
  '';
}
