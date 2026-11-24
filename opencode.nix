# opencode pointed at the local llama-server from llama-cpp.nix. Run
# `opencode` in a project; the default model is the local one.
#
# Nothing should leave the machine. These are the outbound paths in
# opencode 1.15 and how each is closed off (from reading the built binary):
#   - models.dev catalogue: fetched at start and refreshed hourly unless
#     OPENCODE_DISABLE_MODELS_FETCH is set; nixpkgs bundles a snapshot, so
#     the built-in provider list still works without it.
#   - update check: contacts the registry for the latest version unless
#     autoupdate = false (OPENCODE_DISABLE_AUTOUPDATE does the same).
#   - default plugins (opencode-copilot-auth, opencode-openai-codex-auth):
#     installed from npm at startup unless OPENCODE_DISABLE_DEFAULT_PLUGINS.
#   - LSP servers missing from PATH: downloaded unless
#     OPENCODE_DISABLE_LSP_DOWNLOAD. Servers already on PATH are still used.
#   - websearch (mcp.exa.ai) and webfetch tools: callable by the model;
#     disabled below.
#   - session sharing to opencode.ai: share = "disabled".
# The @ai-sdk/openai-compatible provider package is bundled in the binary,
# so the local provider needs no runtime install.
{ pkgs, ... }:
let
  opencode = pkgs.symlinkJoin {
    name = "opencode-local";
    paths = [ pkgs.opencode ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/opencode \
        --set OPENCODE_DISABLE_MODELS_FETCH 1 \
        --set OPENCODE_DISABLE_AUTOUPDATE 1 \
        --set OPENCODE_DISABLE_DEFAULT_PLUGINS 1 \
        --set OPENCODE_DISABLE_LSP_DOWNLOAD 1
    '';
    inherit (pkgs.opencode) meta;
  };
in
{
  programs.opencode = {
    enable = true;
    package = opencode;
    settings = {
      model = "llama/qwen3-coder";
      small_model = "llama/qwen3-coder";
      autoupdate = false;
      share = "disabled";
      tools = {
        websearch = false;
        webfetch = false;
      };
      # Only the local provider; the bundled catalogue of hosted providers
      # is ignored even if credentials for one of them turn up in the env.
      enabled_providers = [ "llama" ];
      provider.llama = {
        npm = "@ai-sdk/openai-compatible";
        name = "llama.cpp (local)";
        options.baseURL = "http://127.0.0.1:8080/v1";
        # Ids must match the preset names served by llama-server.
        models."qwen3-coder" = {
          name = "Qwen3 Coder 30B-A3B (local)";
          tool_call = true;
          # Mirrors ctx-size in llama-cpp.nix so opencode compacts in time.
          limit = {
            context = 32768;
            output = 8192;
          };
        };
      };
    };
  };
}
