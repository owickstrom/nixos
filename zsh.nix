{
  config,
  lib,
  pkgs,
  ...
}:
{

  programs.fzf.enable = true;
  programs.fzf.defaultOptions = [ "--color=16" ];
  programs.zsh = {
    defaultKeymap = "emacs";
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    autocd = true;
    shellAliases = {
      ll = "ls -l";
      lla = "ls -la";
      g = "git";
      gs = "git status";
      gaa = "git add --all";
      gd = "git diff";
      gdc = "git diff --cached";
      gps = "git push";
      gpl = "git pull";
      copy-to-clipboard = "xclip -selection clipboard";
    };
    envExtra = ''
      # Nix
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
      # End Nix

      if [ -e "$HOME/.cargo/env" ]; then
        . "$HOME/.cargo/env"
      fi
    '';
    initContent = ''
      # For home-manager
      export NIX_PATH=$HOME/.nix-defexpr/channels''${NIX_PATH:+:}$NIX_PATH

      _my_theme_vcs_info() {
        jj_prompt_template_raw ' "[" ++ concat( separate(" ", "%B" ++ format_short_change_id_with_change_offset(self) ++ "%b", bookmarks,if(conflict,label("conflict","conflict")), "%F{green}+" ++ self.diff().stat(0).total_added() ++ "%f/%F{red}-" ++ self.diff().stat(0).total_removed() ++ "%f", coalesce(truncate_end(20, self.description().first_line(), "…"), "(no description)")) )++"]" ' \
        || git_prompt_info
      }

      PROMPT='%~ $(_my_theme_vcs_info)» '

      eval "$(direnv hook zsh)"
    '';
    profileExtra = ''
      export XDG_DATA_DIRS=$HOME/.nix-profile/share:/usr/local/share:/usr/share

      [ -f "/opt/homebrew/bin/brew" ] && eval "$(/opt/homebrew/bin/brew shellenv)"

      export PATH=$PATH:$HOME/.local/bin
      export PATH="$HOME/.bun/bin:$PATH"

      export EDITOR="nvim"
      export VISUAL="nvim"
      alias vim=nvim

      export FZF_DEFAULT_COMMAND='rg --files --hidden'
      export FZF_DEFAULT_OPTS='--color=16'
    '';
  };

  programs.zsh.oh-my-zsh = {
    enable = true;
    plugins = [
      "git"
      "jj"
    ];
    theme = "minimal";
  };

  programs.autojump.enable = true;
}
