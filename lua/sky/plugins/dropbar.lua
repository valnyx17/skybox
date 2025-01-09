return {
    "Bekaboo/dropbar.nvim",
    enabled = false,
    event = "LspAttach",
    opts = {
        bar = {
            update_debounce = 100,
            enabled = function(buf, win, _)
                return vim.api.nvim_buf_is_valid(buf)
                    and vim.api.nvim_win_is_valid(win)
                    and vim.wo[win].winbar == ''
                    and vim.fn.win_gettype(win) == ''
                    and vim.bo[buf].ft ~= 'help'
                    and ((pcall(vim.treesitter.get_parser, buf)) and true or false)
                    and vim.fn.getbufinfo(buf)[1].hidden ~= 1
            end,
            sources = function(buf, _)
                local sources = require('dropbar.sources')
                local utils = require('dropbar.utils')

                if vim.bo[buf].ft == 'markdown' then return { sources.markdown } end
                if vim.bo[buf].buftype == 'terminal' then return { sources.terminal } end
                return {
                    utils.source.fallback({
                        sources.lsp,
                        sources.treesitter,
                    }),
                }
            end
        },
        icons = {
            ui = { bar = { separator = ' ' .. sky.ui.icons.r_chev .. ' ' } },
        }
    }
}
