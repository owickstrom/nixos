local neogit = require('neogit')
neogit.setup {
  kind = "tab",
  commit_editor = { kind = "tab" },
  integrations = {
    diffview = true,
  },
}

require "gitlinker".setup()
