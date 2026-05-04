{
  config,
  pkgs,
  lib,
  ...
}:
{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "claude" ''
      original_cwd="$(pwd)"
      cd ~/src/star || exit 1
      if [ -f flake.nix ]; then
        echo "nix --extra-experimental-features 'nix-command flakes' develop --command claude" | exec direnv exec . dev claude.debug_sandbox "$original_cwd"
      else
        exec direnv exec . dev claude "$original_cwd"
      fi
    '')
    (pkgs.writeShellScriptBin "claude-no-flake" ''
      original_cwd="$(pwd)"
      cd ~/src/star || exit 1
      exec direnv exec . dev claude "$original_cwd"
    '')
  ];
}
