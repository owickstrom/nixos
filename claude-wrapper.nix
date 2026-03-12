{ config, pkgs, lib, ... }:
{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "claude" ''
      original_cwd="$(pwd)"
      cd ~/src/star || exit 1
      echo "nix --extra-experimental-features 'nix-command flakes' develop --command claude" | exec direnv exec . dev claude.debug_sandbox "$original_cwd"
    '')
  ];
}
