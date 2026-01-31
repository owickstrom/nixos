{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      # lsp/langs, debugging
      # nvim-lspconfig
      (nvim-treesitter.withPlugins (p: [
        p.bash
        p.go
        p.java
        p.json
        p.lua
        p.markdown
        p.nix
        p.python
        p.rust
        p.zig
        p.vimdoc
        p.graphql
      ]))
      nvim-jdtls
      nvim-dap
      nvim-dap-ui
      nvim-dap-vscode-js
      nvim-dap-virtual-text
      rustaceanvim
      # git
      neogit
      gitlinker-nvim
      # other
      lualine-nvim
      lualine-lsp-progress
      conform-nvim
      fzf-lua
      which-key-nvim
      lush-nvim
      zenbones-nvim
      goyo
      lean-nvim
    ];
    extraConfig = ''
      source /home/owi/nixos/vim/init.vim
    '';
    extraPackages = with pkgs; [
      lua-language-server
      jdt-language-server
    ];
    extraWrapperArgs = [
      "--add-flags"
      "--listen /tmp/$RANDOM.nvim.pipe"
    ];
  };

  xdg.configFile."zls.json".text = ''
    {
      "enable_build_on_save": true
    }
  '';

  xdg.configFile."nvim/colors/lancia.lua".source =
    config.lib.file.mkOutOfStoreSymlink ./vim/colors/lancia.lua;
}
