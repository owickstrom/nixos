
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
})

vim.lsp.config('rust_analyzer', {
  -- Server-specific settings. See `:help lspconfig-setup`
  settings = {
    ['rust-analyzer'] = {
      cargo = {
        loadOutDirsFromCheck = true,
      },
    },
  },
})

vim.lsp.config('hls', {
  filetypes = { 'haskell', 'lhaskell', 'cabal' },
})

vim.lsp.config('jdtls', {
  settings = {
    java = {
      format = {
        enabled = false,
      },
      configuration = {
        updateBuildConfiguration = "interactive",
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      signatureHelp = { enabled = true },
      completion = { guessMethodArguments = true },
    }
  }
})

vim.lsp.enable({
  'lua_ls',
  'rust_analyzer',
  'hls',
  'jdtls',
  'zls',
  'clangd',
  'ts_ls',
  'biome',
  'pyright',
  'gopls',
})

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '',
  command = 'TSEnable highlight'
})

-- https://github.com/neovim/neovim/issues/30985
for _, method in ipairs({ 'textDocument/diagnostic', 'workspace/diagnostic' }) do
  local default_diagnostic_handler = vim.lsp.handlers[method]
  vim.lsp.handlers[method] = function(err, result, context, config)
    if err ~= nil and err.code == -32802 then
      return
    end
    return default_diagnostic_handler(err, result, context, config)
  end
end

-- require("copilot").setup({
--   suggestion = {
--     enabled = true,
--     auto_trigger = true,
--   },
--   filetypes = {
--     ["*"] = true,
--   },
-- })
-- require("CopilotChat").setup {}
