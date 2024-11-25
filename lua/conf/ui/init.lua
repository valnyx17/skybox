-- all based off of https://github.com/mcauley-penney/nvim
require("conf.ui.statusline")

local S = vim.diagnostic.severity
local icons = tools.ui.icons

local lsp_signs = {
    [S.ERROR] = { name = "Error", sym = icons["ballot_x"] },
    [S.WARN] = { name = "Warn", sym = icons["up_tri"] },
    [S.INFO] = { name = "Info", sym = icons["info_i"] },
    [S.HINT] = { name = "Hint", sym = icons["info_i"] },
}

vim.diagnostic.config({
    underline = true,
    severity_sort = true,
    virtual_text = false,
    float = {
        header = ' ',
        border = tools.ui.cur_border,
        source = 'if_many',
        title = { { ' 󰌶 Diagnostics ', 'FloatTitle' } },
        prefix = function(diag)
            local lsp_sym = lsp_signs[diag.severity].sym
            local prefix = string.format(" %s  ", lsp_sym)

            local severity = vim.diagnostic.severity[diag.severity]
            local diag_hl_name = severity:sub(1, 1) .. severity:sub(2):lower()
            return prefix, 'Diagnostic' .. diag_hl_name:gsub('^%l', string.upper)
        end,
    },
    signs = {
        text = {
            [S.ERROR] = tools.ui.icons.ballot_x,
            [S.HINT] = tools.ui.icons.info_i,
            [S.INFO] = tools.ui.icons.info_i,
            [S.WARN] = tools.ui.icons.up_tri,
        }
    }
})

-- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview

function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = tools.ui.cur_border
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
end
