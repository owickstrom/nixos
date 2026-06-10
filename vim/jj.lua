vim.api.nvim_create_user_command("JJDiff", function(opts)
  local base_rev = opts.args ~= "" and opts.args or "trunk()"

  local base = vim.fn.system(
    "jj log -r '" .. base_rev .. "' --no-graph -T 'commit_id.short()' 2>/dev/null"
  ):gsub("\n", "")

  local head = vim.fn.system(
    "jj log -r '@-' --no-graph -T 'commit_id.short()' 2>/dev/null"
  ):gsub("\n", "")

  vim.fn.system("jj git export")
  vim.cmd("DiffviewOpen " .. base .. ".." .. head)
end, { nargs = "?" })
