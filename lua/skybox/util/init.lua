local LazyUtil = require("lazy.core.util")

---@class skybox.util
---@field ui skybox.util.ui
---@field pick skybox.util.pick
---@field heirline skybox.util.heirline
---@field root skybox.util.root
---@field mini skybox.util.mini
---@field lsp skybox.util.lsp
---@field keymap skybox.util.keymap
local M = setmetatable({}, {
  __index = function(t, k)
    if LazyUtil[k] then
      return LazyUtil[k]
    end

    ---@diagnostic disable-next-line: no-unknown
    t[k] = require('skybox.util.' .. k)
    return t[k]
  end
})

function M.is_win()
  return vim.uv.os_uname().sysname:find("Windows") ~= nil
end

---@param fn fun()
---@param once boolean?
function M.on_very_lazy(fn, once)
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    once = once ~= nil and once or false,
    callback = function()
      fn()
    end
  })
end

--- This extends a deeply nested list with a key in a table
--- that is a dot-separated string.
--- The nested list will be created if it does not exist.
---@generic T
---@param t T[]
---@param key string
---@param values T[]
---@return T[]?
function M.extend(t, key, values)
  local keys = vim.split(key, ".", { plain = true })
  for i = 1, #keys do
    local k = keys[i]
    t[k] = t[k] or {}
    if type(t) ~= "table" then
      return
    end
    t = t[k]
  end
  return vim.list_extend(t, values)
end

local cache = {} ---@type table<(fun()), table<string, any>>
---@generic T: fun()
---@param fn T
---@return T
function M.memoize(fn)
  return function(...)
    local key = vim.inspect({ ... })
    cache[fn] = cache[fn] or {}
    if cache[fn][key] == nil then
      cache[fn][key] = fn(...)
    end
    return cache[fn][key]
  end
end

function M.split_lines(text)
  local lines = {}
  for line in text:gmatch("[^\r\n]+") do
    line = line:gsub("\t", string.rep(" ", vim.bo.tabstop))
    table.insert(lines, line)
  end
  return lines
end

--- Override the default title for notifications.
for _, level in ipairs({ "info", "warn", "error" }) do
  M[level] = function(msg, opts)
    opts = opts or {}
    opts.title = opts.title or "skybox"
    return LazyUtil[level](msg, opts)
  end
end

function M.is_loaded(name)
  local Config = require('lazy.core.config')
  return Config.plugins[name] and Config.plugins[name]._.loaded
end

---@param name string
---@param fn fun(name:string)
function M.on_load(name, fn)
  if M.is_loaded(name) then
    fn(name)
  else
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyLoad",
      callback = function(event)
        if event.data == name then
          fn(name)
          return true
        end
      end
    })
  end
end

---@param name string
function M.get_plugin(name)
  return require("lazy.core.config").spec.plugins[name]
end

---@param name string
---@param path string?
function M.get_plugin_path(name, path)
  local plugin = M.get_plugin(name)
  path = path and "/" .. path or ""
  return plugin and (plugin.dir .. path)
end

---@param plugin string
function M.has(plugin)
  return M.get_plugin(plugin) ~= nil
end

---@param name string
function M.opts(name)
  local plugin = M.get_plugin(name)
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

function M.setup_lazy()
  local ok, lazy = pcall(require, "lazy")
  if not ok then
    vim.notify("failed to load plugin: lazy.nvim", vim.log.levels.ERROR)
    return
  end

  vim.g.lazy_events_config = {
    simple = {
      LazyFile = { "BufReadPost", "BufNewFile", "BufWritePre" },
      TermUsed = { "TermOpen", "TermEnter", "TermLeave", "TermClose" },
    },
    projects = {
      docker = { "Dockerfile", "compose.y*ml", "docker-compose.y*ml" },
      cpplib = {
        any = { "Makefile", "CMakeLists.txt", "Justfile", "BUILD", "BUILD.bazel" },
        all = { "**/*.cpp", "**/*.h*" }, -- all expresions must match something
      },
    },
  }

  lazy.setup({
    spec = {
      { "bwpge/lazy-events.nvim", import = "lazy-events.import", lazy = false },
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
end

return M
