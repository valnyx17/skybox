vim.loader.enable()

require('viv.opts')
require('viv.lazy')
_G.viv = require('viv.util')
require('viv.keymaps')
local ok, lazy = pcall(require, 'lazy')
if not ok then
  vim.notify("failed to load: lazy.nvim", vim.log.levels.ERROR)
  return
end

lazy.setup({
  spec = {
    { import = "viv.plugins" }
  },
  install = {
    missing = true,
  },
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    enabled = true,
    notify = false,
  },
  dev = {
    path = "~/Documents/code/nvim",
    patterns = { "valnyx17", "valnyx" },
    fallback = false,
  },
  diff = {
    cmd = "diffview.nvim",
  },
  defaults = {
    lazy = false,
    version = false,
    cond = not vim.g.started_by_firenvim,
  },
  browser = "floorp",
  rocks = {
    enabled = false,
    hererocks = false,
  },
  performance = {
    cache = {
      enabled = false,
      disable_events = { "UiEnter" },
    },
    reset_packpath = true,
    rtp = {
      reset = true,
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
