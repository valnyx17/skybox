local M = {}
M.keymap = {}

---creates a keymapping
---@param mode string|string[]
---@param lhs string
---@param rhs string|fun()|fun(): string
---@param opts? vim.keymap.set.Opts
function M.keymap.set(mode, lhs, rhs, opts)
    vim.keymap.set(mode, lhs, rhs, vim.tbl_deep_extend("force", { silent=true, noremap=true }, opts or {}))
end

---creates a mapper
---@param mode string|string[]
---@return fun(lhs: string, rhs: string|fun(), opts?: vim.keymap.set.Opts)
function M.keymap.create_mapper(mode)
    return function(lhs, rhs, opts)
        M.keymap.set(mode, lhs, rhs, opts)
    end
end

function M.keymap.set_fish_style_abbr(abbr, expansion)
  M.keymap.set("ca", abbr, function()
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

return M
