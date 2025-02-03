---@class skybox.util.heirline
local M = {}

M.conditions = require("heirline.conditions")

M.lsp_attached = function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if next(clients) == nil then return false end
  if #clients > 1 then return true end
  for _, client in pairs(clients) do
    if client.name == "copilot" then
      return false
    else
      return true
    end
  end
end

M.fn = require("heirline.utils")

local color = require('lackluster').color

---@class colors
---@field modes table<string, string>
M.colors = {
  modes = {
    n = color.luster,
    i = color.green,
    v = color.blue,
    V = color.blue,
    VBLOCK = color.blue,
    c = color.orange,
    s = color.lack,
    S = color.lack,
    SBLOCK = color.lack,
    R = color.orange,
    r = color.orange,
    ["!"] = color.luster,
    t = color.luster,
    fg = color.gray2,
  },
  lsp_attached = color.green,
  lsp_not_attached = color.gray4,
  filename = color.gray3,
  macro_brackets = color.gray3,
  macro_name = color.green,
  modified = color.gray4,
  diagnostics = {
    error = color.red,
    warning = color.yellow,
    info = color.gray4,
  },
  text = color.gray8,
  git = {
    add = color.green,
    remove = color.orange,
    change = color.gray6
  },
  bg = "#101010"
}

return M
