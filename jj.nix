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

      ui = {
        diff-instructions = false;
        diff-editor = [
          "nvim"
          "-c"
          "DiffEditor $left $right $output"
        ];
      };

      merge-tools.vimdiff = {
        merge-args = [
          "-f"
          "-d"
          "$output"
          "-M"
          "$left"
          "$base"
          "$right"
          "-c"
          "wincmd J"
          "-c"
          "set modifiable"
          "-c"
          "set write"
        ];
        program = "vim";
        merge-tool-edits-conflict-markers = true;
      };

      templates.draft_commit_description = ''
        concat(
          builtin_draft_commit_description,
          "\nJJ: ignore-rest\n",
          diff.git(),
        )
      '';

    };
  };

  programs.difftastic = {
    enable = true;
    jujutsu.enable = true;
  };
}
