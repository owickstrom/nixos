local neogit = require('neogit')
neogit.setup {
  integrations = {
    diffview = true,
  },
}

require "gitlinker".setup()
