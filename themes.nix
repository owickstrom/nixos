{ fetchFromGitHub }:
let
  repo = fetchFromGitHub {
    owner = "zenbones-theme";
    repo = "zenbones.nvim";
    rev = "418fcb2bd45073d258a70d75a17f03e9f73a97a7";
    hash = "sha256-BXm2vMvqIr5QW/MkRUwehjVVG570puVfZAHhflJq2hU=»;";
  };

  zenbones = {
    light = builtins.fromJSON (
      builtins.readFile "${repo}/extras/windows_terminal/zenwritten_light.json"
    );
    dark = builtins.fromJSON (builtins.readFile "${repo}/extras/windows_terminal/zenwritten_dark.json");
  };

  gruvbox = {
    light = {
      "background" = "#FBF1C7";
      "foreground" = "#3C3836";
      "selectionBackground" = "#EBDBB2";
      "black" = "#FBF1C7";
      "blue" = "#458588";
      "brightBlack" = "#928374";
      "brightBlue" = "#076678";
      "brightCyan" = "#427B58";
      "brightGreen" = "#79740E";
      "brightPurple" = "#8F3F71";
      "brightRed" = "#9D0006";
      "brightWhite" = "#3C3836";
      "brightYellow" = "#B57614";
      "cursorColor" = "#928374";
      "cyan" = "#689D6A";
      "green" = "#98971A";
      "name" = "Gruvbox Light";
      "purple" = "#B16286";
      "red" = "#CC241D";
      "white" = "#7C6F64";
      "yellow" = "#D79921";
    };
    dark = {
      "background" = "#282828";
      "foreground" = "#EBDBB2";
      "selectionBackground" = "#3c3836";
      "black" = "#282828";
      "blue" = "#458588";
      "brightBlack" = "#928374";
      "brightBlue" = "#83A598";
      "brightCyan" = "#8EC07C";
      "brightGreen" = "#B8BB26";
      "brightPurple" = "#D3869B";
      "brightRed" = "#FB4934";
      "brightWhite" = "#EBDBB2";
      "brightYellow" = "#FABD2F";
      "cyan" = "#689D6A";
      "green" = "#98971A";
      "name" = "Gruvbox Dark";
      "purple" = "#B16286";
      "red" = "#CC241D";
      "white" = "#A89984";
      "yellow" = "#D79921";
    };
  };
in
gruvbox
