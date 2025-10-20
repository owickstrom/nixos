{ pkgs, ... }:
let
  spotify-wrapped = pkgs.writeShellScriptBin "spotify" ''
    ELECTRON_OZONE_PLATFORM_HINT="wayland" NIXOS_OZONE_WL=1 ${pkgs.spotify}/bin/spotify $@
  '';
in
{
  home.packages = [ spotify-wrapped ];
}
