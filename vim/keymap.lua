local neogit = require('neogit')
local dap = require("dap")
local dapui = require("dapui")
local dap_vscode = require("dap.ext.vscode")
local fzf_lua = require("fzf-lua")
local wk = require("which-key")

-- completion (not part of which-key, insert mode)
vim.keymap.set('i', '<C-Space>', '<C-x><C-o>')

wk.add({
  -- groups
  { "<leader>b", group = "buffer" },
  { "<leader>f", group = "file" },
  { "<leader>t", group = "tab" },
  { "<leader>g", group = "git" },
  { "<leader>c", group = "code" },
  { "<leader>cw", group = "workspace" },
  { "<leader>a", group = "ai" },
  { "<leader>d", group = "debug" },

  -- buffers
  { "[b", ":bprev<cr>", desc = "Previous buffer" },
  { "]b", ":bnext<cr>", desc = "Next buffer" },
  { "<leader>bb", ":FzfLua buffers<cr>", desc = "Find buffer" },
  { "<leader>bd", ":bdelete<cr>", desc = "Delete buffer" },

  -- files
  { "<leader><leader>", ":FzfLua files<cr>", desc = "Find file" },
  { "<leader>ff", ":FzfLua files<cr>", desc = "Find file" },
  { "<leader>fs", ":FzfLua grep<space>", desc = "Grep" },

  -- tabs
  { "[t", ":tabprev<cr>", desc = "Previous tab" },
  { "]t", ":tabnext<cr>", desc = "Next tab" },
  { "<leader>tn", ":tabnew<cr>", desc = "New tab" },
  { "<leader>tf", ":FzfLua tabs<cr>", desc = "Find tab" },
  { "<leader>tc", ":tabclose<cr>", desc = "Close tab" },

  -- quickfix
  { "[q", ":cprev<cr>", desc = "Previous quickfix" },
  { "]q", ":cnext<cr>", desc = "Next quickfix" },

  -- git
  { "<leader>gg", neogit.open, desc = "Neogit" },
  { "<leader>gf", ":FzfLua git_files<cr>", desc = "Find git file" },
  { "<leader>gl", ":FzfLua git_commits<cr>", desc = "Log" },
  { "<leader>gb", ":FzfLua git_branches<cr>", desc = "Branches" },

  -- lsp
  { "[d", vim.diagnostic.goto_prev, desc = "Previous diagnostic" },
  { "]d", vim.diagnostic.goto_next, desc = "Next diagnostic" },
  { "K", vim.lsp.buf.hover, desc = "Hover" },
  { "<leader>cr", vim.lsp.buf.rename, desc = "Rename" },
  { "<leader>ca", ":FzfLua lsp_code_actions<cr>", desc = "Code actions" },
  { "<leader>cf", ":FzfLua lsp_finder<cr>", desc = "Finder" },
  { "<leader>cd", vim.lsp.buf.definition, desc = "Go to definition" },
  { "<leader>cD", vim.lsp.buf.declaration, desc = "Go to declaration" },
  { "<leader>cu", ":FzfLua lsp_references<cr>", desc = "References" },
  { "<leader>ch", vim.lsp.buf.signature_help, desc = "Signature help" },
  { "<leader>cws", ":FzfLua lsp_live_workspace_symbols<cr>", desc = "Symbols" },
  { "<leader>cwd", ":FzfLua lsp_workspace_diagnostics<cr>", desc = "Diagnostics" },

  -- ai
  { "<leader>ac", ":CopilotChat<cr>", desc = "Chat" },
  { "<leader>ae", ":CopilotChatExplain<cr>", desc = "Explain" },
  { "<leader>ar", ":CopilotChatReview<cr>", desc = "Review" },

  -- debug (function keys)
  { "<F5>", function()
    if dap.session() then
      dap.continue()
    else
      fzf_lua.dap_configurations()
    end
  end, desc = "Continue / launch" },
  { "<F9>", dap.toggle_breakpoint, desc = "Toggle breakpoint" },
  { "<F10>", dap.step_over, desc = "Step over" },
  { "<F11>", dap.step_into, desc = "Step into" },
  { "<F12>", dap.step_out, desc = "Step out" },

  -- debug (leader)
  { "<leader>dt", dap.terminate, desc = "Terminate" },
  { "<leader>du", dapui.toggle, desc = "Toggle UI" },
  { "<leader>db", dap.toggle_breakpoint, desc = "Toggle breakpoint" },
  { "<leader>dl", fzf_lua.dap_breakpoints, desc = "List breakpoints" },
  { "<leader>dr", dap_vscode.load_launchjs, desc = "Load launch.json" },
  { "<leader>dB", function()
    dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
  end, desc = "Conditional breakpoint" },
})
