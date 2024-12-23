return {
    "echasnovski/mini.nvim",
    config = function()
        prequire('mini.ai').setup({
            n_lines = 500,
            custom_textobjects = {
                g = require('mini.extra').gen_ai_spec.buffer()
            }
        })

        prequire('mini.move').setup()
        -- prequire('mini.align').setup()

        prequire('mini.jump').setup({
            mappings = {
                forward = 'f',
                backward = 'F',
                forward_till = 't',
                backward_till = 'T',
                repeat_jump = ';',
            },
            delay = {
                highlight = 100,
                idle_stop = 10000000000000
            }
        })

        prequire('mini.jump2d').setup()

        prequire('mini.basics').setup({
            options = {
                basic = false
            },
            mappings = {
                basic = false,
                move_with_alt = true
            },
            autocommands = {
                basic = true,
            }
        })

        prequire('mini.files').setup({})
        vim.keymap.set("n", "<leader>fe", function()
            if require('mini.files').get_explorer_state() ~= nil then
                require('mini.files').close()
                return
            end
            require('mini.files').open()
        end, {
            desc = "open mini.files",
        })

        prequire('mini.comment').setup()

        prequire('mini.surround').setup({
            mappings = {
                add = 'ys',             -- Add surrounding in Normal and Visual modes
                delete = 'ds',          -- Delete surrounding
                find = 'gsf',           -- Find surrounding (to the right)
                find_left = 'gsF',      -- Find surrounding (to the left)
                highlight = 'gsh',      -- Highlight surrounding
                replace = 'cs',         -- Replace surrounding
                update_n_lines = 'gsn', -- Update `n_lines`

                suffix_last = 'l',      -- Suffix to search with "prev" method
                suffix_next = 'n',      -- Suffix to search with "next" method
            }
        })

        prequire('mini.diff').setup({
            view = {
                style = "sign",
                signs = {
                    add = "┃",
                    change = "┃",
                    delete = "",
                },
            },
        })

        prequire('mini.bracketed').setup()
    end
}
