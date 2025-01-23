---@class skybox.util.pick
---@overload fun(command:string, opts?:skybox.util.pick.Opts): fun()
local M = setmetatable({}, {
  __call = function(m, ...)
    return m.wrap(...)
  end
})

---@class skybox.util.pick.Opts: table<string, any>
---@field root? boolean
---@field cwd? string
---@field buf? number
---@field show_untracked? boolean

---@class Picker
---@field name string
---@field open fun(command:string, opts?:skybox.util.pick.Opts)
---@field commands table<string, string>

---@class FzfLuaOpts: skybox.util.pick.Opts
---@field cmd string?

---@type Picker?
M.picker = {
  name = "fzf",
  commands = {
    files = "files"
  },

  ---@param command string
  ---@param opts? FzfLuaOpts
  open = function(command, opts)
    opts = opts or {}
    if opts.cmd == nil and command == "git_files" and opts.show_untracked then
      opts.cmd = "git ls-files --exclude-standard --cached --others"
    end
    return require("fzf-lua")[command](opts)
  end
}

---@param command? string
---@param opts? skybox.util.pick.Opts
function M.open(command, opts)
  if not M.picker then
    Skybox.error("Skybox.pick: what")
  end

  command = command ~= "auto" and command or "files"
  opts = opts or {}

  opts = vim.deepcopy(opts)

  if not opts.cwd and opts.root ~= false then
    opts.cwd = Skybox.root({ buf = opts.buf })
  end

  command = M.picker.commands[command] or command
  M.picker.open(command, opts)
end

---@param command? string
---@param opts? skybox.util.pick.Opts
function M.wrap(command, opts)
  opts = opts or {}
  return function()
    Skybox.pick.open(command, vim.deepcopy(opts))
  end
end

function M.config_files()
  return M.wrap("files", { cwd = vim.fn.stdpath("config") })
end

return M
