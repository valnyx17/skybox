---@class viv.util.keymap
local M = setmetatable({}, {
    __call = function(m, ...)
        return m.set(...)
    end,
    __index = function(t, k)
        if vim.regex("^\\(set\\(\\a\\)\\+\\)\\{1}$"):match_str(k) then
            local mode = string.sub(k, 4, #k)
            -- code from https://github.com/telemachus/split/blob/main/src/split.lua
            if #mode > 1 then
                local s = {}
                for i=1, #mode do
                    s[#s + 1] = string.sub(mode, i, i)
                end
                mode = s
            end
            return t.create_mapper(mode)
        end
        return t[k]
    end
})

---@alias mode string|string[]
---@alias rhs string|fun()|fun():string
---@alias opts vim.keymap.set.Opts

--- creates a keymapping
---@param mode mode
---@param lhs string
---@param rhs rhs
---@param desc? string
---@param opts? opts
function M.set(mode, lhs, rhs, opts)
    desc = desc or ""
    vim.keymap.set(mode, lhs, rhs, vim.tbl_deep_extend("force", { silent = true, noremap = true }, opts or {}))
end

--- creates a setter for a mode
---@param mode string|string[]
---@return fun(lhs: string, rhs: rhs, opts?: opts)
function M.create_mapper(mode)
    return function(lhs, rhs, opts)
        M.set(mode, lhs, rhs, opts)
    end
end

--- Creates a fish-style abbreviation.
---@param abbr string
---@param expansion string
function M.cmdline_abbr(abbr, expansion)
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

return M
