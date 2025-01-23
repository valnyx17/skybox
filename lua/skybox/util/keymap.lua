---@class skybox.util.keymap
local M = setmetatable({}, {
  __call = function(m, ...)
    return m.set(...)
  end
})

---@alias mode string|string[]
---@alias rhs string|fun()|fun():string
---@alias opts vim.keymap.set.Opts

---creates a keymapping
---@param mode mode
---@param lhs string
---@param rhs rhs
---@param opts? opts
function M.set(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, vim.tbl_deep_extend("force", { silent = true, noremap = true }, opts or {}))
end

--- creates a mapper
---@param mode string|string[]
---@return fun(lhs: string, rhs: rhs, opts?: opts)
M.create_mapper = Skybox.memoize(function(mode)
  return function(lhs, rhs, opts)
    M.set(mode, lhs, rhs, opts)
  end
end)

--- Creates a fish-style abbreviation.
---@param abbr string
---@param expansion string
function M.set_fish_style_abbr(abbr, expansion)
  M.set("ca", abbr, function()
    local cmdline = vim.fn.getcmdline()
    local first_word = cmdline:match("%S+")
    local typing_command = vim.fn.getcmdtype() == ":" and vim.fn.getcmdpos() == (#first_word + 1)
    if not typing_command then
      return abbr
    end
    if type(expansion) == "function" then
      return expansion() or abbr
    end
    return expansion
  end, { remap = false, expr = true })
end

--- Creates an animated paste.
---@param cmd "p"|"P"
---@param mode "n"|"V"
-- function M.animated_paste(cmd, mode)
--   local paste_mode = vim.opt.paste:get()
--   local text = Skybox.split_lines(vim.fn.getreg('"', true))
--
--   local keys = cmd
--   if cmd == "p" then
--     keys = (mode == "n") and "p=`]" or '"_dkp=`]'
--   elseif cmd == "P" then
--     keys = (mode == "n") and "P=`]" or '"_dP=`]'
--   end
--
--   vim.fn.feedkeys(keys, mode)
--   vim.opt.paste = paste_mode
--
--   if vim.fn.exists(":TinyGlimmer") then
--     vim.schedule(function()
--       local range = require('tiny-glimmer.utils').get_range_last_modification()
--
--       require('tiny-glimmer.animation.factory').get_instance():create_text_animation("fade", {
--         base = {
--           range = range,
--         },
--         content = text
--       })
--     end)
--   end
-- end

M.animated_search = function(keys, search_pattern)
  local buf = vim.api.nvim_get_current_buf()

  if keys ~= nil then
    vim.fn.feedkeys(keys, "n")
  end

  if vim.fn.exists(":TinyGlimmer") then
    vim.schedule(function()
      local cursor_pos = vim.api.nvim_win_get_cursor(0)
      local matches = vim.fn.matchbufline(buf, search_pattern, cursor_pos[1], cursor_pos[1])

      if vim.tbl_isempty(matches) then
        return
      end

      local range = {
        start_line = cursor_pos[1] - 1,
        start_col = cursor_pos[2],
        end_line = cursor_pos[1] - 1,
        end_col = cursor_pos[2] + #matches[1].text,
      }

      require("tiny-glimmer.animation.factory")
          .get_instance()
          :create_text_animation("fade", {
            base = {
              range = range,
            },
            content = matches[1].text
          })
    end)
  end
end

return M
