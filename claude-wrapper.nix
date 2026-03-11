{ config, pkgs, lib, ... }:
{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "claude" ''
      original_cwd="$(pwd)"
      cd ~/src/star || exit 1
      exec direnv exec . dev claude "$original_cwd"
    '')
  ];
}
