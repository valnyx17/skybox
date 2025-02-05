---@class skybox.util.heirline
local M = {}
local api = vim.api
local v = vim.v

M.conditions = require('heirline.conditions')
M.lsp_attached = function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if next(clients) == nil then return false end
  if #clients > 1 then return true end
  for _, client in pairs(clients) do
    if client.name == "copilot" then return false else return true end
  end
end

M.fn = require("heirline.utils")

function M.get_num_wraps()
  local winid = api.nvim_get_current_win()
  return api.nvim_win_text_height(winid, {
    start_row = v.lnum - 1,
    end_row = v.lnum - 1,
  })["all"]
end

function M.swap(start_val, end_val)
  if start_val > end_val then
    local swap_val = start_val
    start_val = end_val
    end_val = swap_val
  end

  return start_val, end_val
end

function M.get_buf_width()
  local winid = api.nvim_get_current_win()
  local winfo = vim.fn.getwininfo(winid)[1]
  return winfo["width"] - winfo["textoff"]
end


M.gsign_ns = api.nvim_create_namespace("gitsigns_signs_")
M.mdiff_ns = api.nvim_create_namespace("MiniDiffViz")
function M.get_signs(bufnr, lnum)
  local signs = {}

  local extmarks = api.nvim_buf_get_extmarks(
    0,
    -1,
    { v.lnum - 1, 0 },
    { v.lnum - 1, -1 },
    { details = true, type = "sign" }
  )

  for _, extmark in pairs(extmarks) do
    -- exclude gitsigns & mini.diff
    if (extmark[4].ns_id ~= gsign_ns) and (extmark[4].ns_id ~= mdiff_ns) then
      signs[#signs + 1] = {
        name = extmark[4].sign_hl_group or "",
        text = extmark[4].sign_text,
        sign_hl_group = extmark[4].sign_hl_group,
        priority = extmark[4].priority,
      }
    end
  end

  table.sort(signs, function(a, b)
    return (a.priority or 0) > (b.priority or 0)
  end)

  return signs
end

M.Spacer = { provider = " " }
M.Aligner = { provider = "%=" }

return M
