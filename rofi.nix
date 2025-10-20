{
  pkgs,
  config,
  lib,
  ...
}:
let
  themes = pkgs.callPackage ./themes.nix { };
  makeTheme = theme: ''
    * {
        background-color: ${theme.background};
        border-color:     ${theme.foreground};
        font:             "Alegreya Sans 10";
        text-color:       ${theme.foreground};
    }
    window {
        width:    100.0000% ;
        padding:  4px ;
        anchor:   north;
        location: north;
        children: [ "horibox" ];
    }
    horibox {
        orientation: horizontal;
        children:    [ "prompt","entry","listview" ];
    }
    listview {
        layout:  horizontal;
        spacing: 5px ;
        lines:   100;
    }
    entry {
        width:  10.0000em ;
        expand: false;
    }
    element {
        padding: 0px 2px ;
    }
    element selected {
        background-color: ${theme.foreground};
        text-color: ${theme.background};
    }
    element-text {
        background-color: inherit;
        text-color:       inherit;
    }
    element-icon {
        background-color: inherit;
        text-color:       inherit;
    }
  '';
  rofi-wrapped = pkgs.writeShellScriptBin "rofi" ''
    theme=$(dconf read /org/gnome/desktop/interface/color-scheme | sed "s/'//g" | sed "s/prefer-//g")
    ${pkgs.rofi}/bin/rofi -terminal ${pkgs.ghostty}/bin/ghostty -theme zenbones-$theme $@
  '';
in
{
  home.packages = [ rofi-wrapped ];

  xdg.dataFile."rofi/themes/zenbones-dark.rasi".text = makeTheme themes.dark;
  xdg.dataFile."rofi/themes/zenbones-light.rasi".text = makeTheme themes.light;
}
