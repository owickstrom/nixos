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
      nvim-lspconfig
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
      diffview-nvim
      # other
      conform-nvim
      fzf-lua
      lean-nvim
      lualine-lsp-progress
      lualine-nvim
      lush-nvim
      unicode-vim
      which-key-nvim
      zenbones-nvim
    ];
    extraConfig = ''
      " For faster startup
      lua vim.loader.enable()

      " portable vimscript
      source ${config.home.homeDirectory}/nixos/vim/init.vim

      " nix-specific
      " let g:zenbones_darkness='stark'
      colorscheme lancia

      luafile ${config.home.homeDirectory}/nixos/vim/fold.lua
      luafile ${config.home.homeDirectory}/nixos/vim/completion.lua
      luafile ${config.home.homeDirectory}/nixos/vim/debugging.lua
      luafile ${config.home.homeDirectory}/nixos/vim/formatting.lua
      luafile ${config.home.homeDirectory}/nixos/vim/git.lua
      luafile ${config.home.homeDirectory}/nixos/vim/keymap.lua
      luafile ${config.home.homeDirectory}/nixos/vim/line.lua
      luafile ${config.home.homeDirectory}/nixos/vim/lsp.lua
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

  home.activation.vimSymlinks = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD mkdir -p ~/.config/nvim/colors
    $DRY_RUN_CMD ln -sfn ${config.home.homeDirectory}/nixos/vim/colors/lancia.lua ~/.config/nvim/colors/lancia.lua
  '';
}
