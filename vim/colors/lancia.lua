local colors_name = "lancia-dark"
vim.g.colors_name = colors_name -- Required when defining a colorscheme

local lush = require "lush"
local hsluv = lush.hsluv -- Human-friendly hsl
local util = require "zenbones.util"

local bg = vim.o.background

-- Define a palette. Use `palette_extend` to fill unspecified colors
-- Based on https://github.com/gruvbox-community/gruvbox#palette
local palette
if bg == "light" then
  palette = util.palette_extend({
    bg = hsluv "#ffffff",
    fg = hsluv "#111111",
    muted = hsluv "#888888",
    muted_extra = hsluv "#aaaaaa",
    paren = hsluv "#555555",
    hint = hsluv "#555555",
    warning = hsluv "#d9961a",
    error = hsluv "#ec3305",
  }, bg)
else
  palette = util.palette_extend({
    bg = hsluv "#000000",
    fg = hsluv "#ed6405",
    muted = hsluv "#8a4b2b",
    muted_extra = hsluv "#563422",
    paren = hsluv "#b36957",
    hint = hsluv "#8e5832",
    warning = hsluv "#b18532",
    error = hsluv "#ec3305",
  }, bg)
end

-- Generate the lush specs using the generator util
local generator = require "zenbones.specs"
local base_specs = generator.generate(palette, bg, generator.get_global_config(colors_name, bg))

-- Optionally extend specs using Lush
local specs = lush.extends({ base_specs }).with(function()
  return {
    Comment { fg = palette.muted },
    LineNr { fg = palette.muted_extra },
    Statement { base_specs.Statement, fg = palette.fg },
    Special { fg = palette.fg },
    Type { fg = palette.fg, gui = "italic" },
    Delimiter { fg = palette.paren },
    Error { fg = palette.error },
    DiagnosticInfo { fg = palette.fg },
    DiagnosticUnderlineError { sp = palette.error, gui = "undercurl", term = "undercurl" },
    DiagnosticUnderlineWarn { sp = palette.warning, gui = "undercurl", term = "undercurl" },
    DiagnosticUnderlineHint { sp = palette.hint, gui = "undercurl", term = "undercurl", fg = palette.fg },
    DiagnosticUnderlineInfo { sp = palette.hint, gui = "undercurl", term = "undercurl" },
  }
end)

-- Pass the specs to lush to apply
lush(specs)

-- Optionally set term colors
require("zenbones.term").apply_colors(palette)
