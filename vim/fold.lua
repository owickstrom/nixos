vim.o.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldtext = ""

-- Some trial defaults based off https://www.jackfranklin.co.uk/blog/code-folding-in-vim-neovim/
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 6
vim.opt.foldnestmax = 8
