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

  home.packages = [
    (pkgs.writeShellApplication {
      name = "jj-review";
      runtimeInputs = [
        pkgs.jujutsu
      ];
      text = builtins.readFile ./jj-review;
    })
  ];
}
