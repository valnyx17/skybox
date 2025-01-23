vim.g.mapleader = " "
vim.g.maplocalleader = ","

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyurl = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyurl, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

local ok, lazy = pcall(require, "lazy")
if not ok then
  vim.notify("failed to load plugin: lazy.nvim", vim.log.levels.ERROR)
  return
end

_G.Skybox = require("skybox.util")

lazy.setup({
  spec = {
    { import = "skybox.plugins" }
  },
  install = {
    missing = true,
    -- colorscheme = { "evergarden", "default" },
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

vim.cmd [[colorscheme evergarden]]

require("skybox.autocmds")
require("skybox.opts")

Skybox.on_very_lazy(function()
  require("skybox.keymaps")
end, true)
