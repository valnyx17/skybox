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
        prequire('mini.align').setup()

        prequire('mini.basics').setup({
            options = {
                basic = false
            },
            mappings = {
                basic = false,
                move_with_alt = true
            }
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


        local MiniSplitjoin = prequire('mini.splitjoin')

        local pairs = {
            '%b()',
            '%b<>',
            '%b[]',
            '%b{}',
        }

        MiniSplitjoin.setup({
            detect = {
                brackets = pairs,
                separator = '[,;]',
                exclude_regions = {},
            },
            mappings = {
                toggle = 'gS',
            },
        })

        local gen_hook = MiniSplitjoin.gen_hook
        local hook_pairs = { brackets = pairs }
        local add_pair_commas = gen_hook.add_trailing_separator(hook_pairs)
        local del_pair_commas = gen_hook.del_trailing_separator(hook_pairs)
        vim.b.minisplitjoin_config = {
            split = { hooks_post = { add_pair_commas } },
            join  = { hooks_post = { del_pair_commas } },
        }
    end
}
