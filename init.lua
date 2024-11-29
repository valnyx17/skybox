if vim.loader then vim.loader.enable() end

vim.g.mapleader = " "
vim.g.maplocalleader = ","

_G.L = vim.log.levels
_G.I = vim.inspect
_G.prequire = function(name)
    local ok, mod = pcall(require, name)
    if ok then
        return mod
    else
        vim.notify_once(string.format("Missing module: %s", mod), L.WARN)
        return nil
    end
end

require('nyx.globals') -- _G.v namespace

-- inspect the contents of an object very quickly
-- in your code or from the command-line:
-- @see: https://www.reddit.com/r/neovim/comments/p84iu2/useful_functions_to_explore_lua_objects/
-- USAGE:
-- in lua: P({1, 2, 3})
-- in commandline: :lua P(vim.loop)
---@vararg any
_G.P = function(...)
    local printables = {}
    for i = 1, select('#', ...) do
        local v = select(i, ...)
        table.insert(printables, vim.inspect(v))
    end

    if prequire('plenary') then
        local log = prequire('plenary.log').new({
            plugin = "notify",
            level = "debug",
            use_console = true,
            use_quickfix = false,
            use_file = false
        })
        vim.schedule_wrap(log.info)(vim.inspect(#printables > 1 and printables or unpack(printables)))
    else
        vim.schedule_wrap(print)(table.concat(printables, "\n"))
    end
    return ...
end
_G.dbg = _G.P

function vim.wlog(...)
    if vim.in_fast_event() then return vim.schedule_wrap(vim.wlog)(...) end
    local d = debug.getinfo(2)
    return vim.fn.writefile(
        vim.fn.split(":" .. d.short_src .. ":" .. d.currentline .. ":\n" .. vim.inspect(#{ ... } > 1 and { ... } or ...),
            "\n"),
        "/tmp/nvim.log",
        "a"
    )
end

function vim.wlogclear()
    vim.fn.writefile({}, "/tmp/nvim.log")
end

require('nyx.conf')
require('nyx.ui')
require('nyx.lazy')
require('nyx.cmds')
require('nyx.autocmds')

vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        require('nyx.keymaps')
    end
})
