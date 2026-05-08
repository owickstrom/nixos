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
}
