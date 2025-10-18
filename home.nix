{
  config,
  pkgs,
  lib,
  ...
}:
{

  imports = [
    ./hyprland.nix
    ./ghostty.nix
    ./zed.nix
    ./bat.nix
    ./zsh.nix
    ./git.nix
    ./vim.nix
    ./tmux.nix
    ./ctags.nix
    ./gammastep.nix
  ];
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  news.display = "silent";

  nix = {
    gc = {
      automatic = true;
    };
  };

  nixpkgs.config.input-fonts.acceptLicense = true;
  nixpkgs.overlays = [];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "owi";
  home.homeDirectory = "/home/owi";

  # The state version is required and should stay at the version you
  # originally installed.
  home.stateVersion = "25.05";

  fonts.fontconfig.enable = true;

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # Make sure to add these to ~/.config/nix/nix.conf:
  #
  #   keep-derivations = true
  #   keep-outputs = true

  home.packages = with pkgs; [
    # Generally useful apps
    firefox
    papers

    # Git
    difftastic

    # Nix
    nix-prefetch-git
    nixfmt-rfc-style
    nix-tree
    cachix

    # Python
    python313
    uv
    pyright
    python313Packages.black

    # JS
    nodejs
    yarn

    # Fonts
    alegreya
    alegreya-sans
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    inter
    font-awesome

    # Tools
    shellcheck
    btop
    tmux
    jq
    ripgrep
    xclip
    tree
    awscli
    bat
    pandoc

    # Zig
    zig
    zls
  ];
}
