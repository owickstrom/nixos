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
        diff-formatter = ":git";
      };

      "merge-tools".diffview = {
        program = "nvim";
        merge-args = [
          "-c"
          "DiffviewMergeFiles $left $base $right $output"
        ];
      };

      templates.draft_commit_description = ''
        concat(
          builtin_draft_commit_description,
          "\nJJ: ignore-rest\n",
          diff.git(),
        )
      '';

      aliases.review = [
        "util"
        "exec"
        "--"
        "jj-review"
      ];

    };
  };

  programs.difftastic = {
    enable = true;
    jujutsu.enable = false; # doesn't work well on eink
  };

  home.activation.jjReview = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD mkdir -p ~/.local/bin
    $DRY_RUN_CMD ln -sfn ${config.home.homeDirectory}/nixos/jj-review ~/.local/bin/jj-review
  '';
}
