local neogit = require('neogit')
neogit.setup {
  kind = "floating",
  commit_editor = { kind = "floating" },
  integrations = {
    diffview = true,
  },
}

require "gitlinker".setup()
