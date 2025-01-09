return {
    'b0o/incline.nvim',
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        local helpers = require 'incline.helpers'
        local devicons = require 'nvim-web-devicons'
        require('incline').setup {
            window = {
                padding = 0,
                margin = { horizontal = 0 },
            },
            render = function(props)
                local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
                if filename == '' then
                    local dir
                    if vim.bo.filetype == 'oil' then dir = require('oil').get_current_dir() end
                    filename = dir and dir or "[no name]"
                end
                local ft_icon, ft_color = devicons.get_icon_color(filename)
                local modified = vim.bo[props.buf].modified
                -- return {
                --     ft_icon and { ' ', ft_icon, ' ', guibg = ft_color, guifg = helpers.contrast_color(ft_color) } or
                --     '',
                --     ' ',
                --     { filename, gui = modified and 'bold,italic' or 'bold', guifg = '#c5c9c5' },
                --     ' ',
                --     -- guibg = '#21252b',
                --     -- guibg = '#0d0c0c'
                --     guibg = require('sky.ui.utils').colors.theme.ui.float.bg
                -- }
                return {
                    ft_icon and { ft_icon, guifg = ft_color } or '',
                    { " " },
                    { filename, gui = modified and 'bold,italic' or 'None', guifg = '#c5c9c5' },
                    guibg = require('sky.ui.utils').colors.mantle
                }
            end,
        }
    end,
    -- Optional: Lazy load Incline
    event = 'UiEnter',
}
