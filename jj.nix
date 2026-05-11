{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "Oskar Wickström";
        email = "oskar@wickstrom.tech";
      };
    };
  };
  home.activation.jjSymlinks = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD mkdir -p ~/.config/jj
    $DRY_RUN_CMD ln -sfn ${config.home.homeDirectory}/nixos/jj/config.toml ${config.home.homeDirectory}/.config/jj/config.toml
  '';
}
