{ fetchFromGitHub }:
let
  repo = fetchFromGitHub {
    owner = "zenbones-theme";
    repo = "zenbones.nvim";
    rev = "418fcb2bd45073d258a70d75a17f03e9f73a97a7";
    hash = "sha256-BXm2vMvqIr5QW/MkRUwehjVVG570puVfZAHhflJq2hU=»;";
  };
in
{
  light = builtins.fromJSON (
    builtins.readFile "${repo}/extras/windows_terminal/zenwritten_light.json"
  );
  dark = builtins.fromJSON (builtins.readFile "${repo}/extras/windows_terminal/zenwritten_dark.json");
}
