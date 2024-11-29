-- all based off of https://github.com/mcauley-penney/nvim
require("nyx.ui.statusline")

local S = vim.diagnostic.severity
local icons = v.lsp.icons

local lsp_signs = {
    [S.ERROR] = { name = "Error", sym = icons["error"] },
    [S.HINT] = { name = "Hint", sym = icons["hint"] },
    [S.INFO] = { name = "Info", sym = icons["info"] },
    [S.WARN] = { name = "Warn", sym = icons["warn"] },
}

vim.diagnostic.config({
    underline = true,
    severity_sort = true,
    virtual_text = false,
    virtual_lines = { only_current_line = true },
    float = {
        header = ' ',
        border = v.ui.cur_border,
        source = 'if_many',
        title = { { ' 󰌶 Diagnostics ', 'FloatTitle' } },
        prefix = function(diag)
            local lsp_sym = lsp_signs[diag.severity].sym
            local prefix = string.format(" %s  ", lsp_sym)

            local severity = vim.diagnostic.severity[diag.severity]
            local diag_hl_name = severity:sub(1, 1) .. severity:sub(2):lower()
            return prefix, 'Diagnostic' .. diag_hl_name:gsub('^%l', string.upper)
        end,
        format = function(d)
            -- return ("%s (%s) [%s]"):format(d.message, d.source, d.code or d.user_data.lsp.code)
            return ("%s (%s)"):format(d.message, d.source)
        end,
    },
    signs = {
        text = {
            [S.ERROR] = v.lsp.icons.error,
            [S.HINT] = v.lsp.icons.hint,
            [S.INFO] = v.lsp.icons.info,
            [S.WARN] = v.lsp.icons.warn,
        }
    }
})

-- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview

function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = v.ui.cur_border
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
end
