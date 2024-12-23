local M = {}

table.insert(M, {
    "echasnovski/mini.ai",
    dependencies = {
        "echasnovski/mini.extra",
    },
    event = "BufEnter",
    opts = function()
        return {
            n_lines = 500,
            custom_textobjects = {
                g = require("mini.extra").gen_ai_spec.buffer(),
            },
        }
    end,
})

table.insert(M, {
    "echasnovski/mini.move",
    event = "BufEnter",
    opts = {},
})

table.insert(M, {
    "echasnovski/mini.jump",
    event = "BufEnter",
    opts = {
        mappings = {
            forward = "f",
            backward = "F",
            forward_till = "t",
            backward_till = "T",
            repeat_jump = ";",
        },
        delay = {
            highlight = 100,
            idle_stop = 10000000000000,
        },
    },
})

table.insert(M, {
    "echasnovski/mini.jump2d",
    event = "BufEnter",
    opts = {},
})

table.insert(M, {
    "echasnovski/mini.basics",
    event = "UiEnter",
    opts = {
        options = {
            basic = false,
        },
        mappings = {
            basic = false,
            move_with_alt = true,
        },
        autocommands = {
            basic = true,
        },
    },
})

-- table.insert(M, {
--     'echasnovski/mini.files',
--     keys = {
--         {
--             "<leader>fe",
--             function()
--                 if require('mini.files').get_explorer_status ~= nil then
--                     require('mini.files').close()
--                     return
--                 end
--                 require('mini.files').open()
--             end,
--             desc = "open mini.files",
--         }
--     },
--     opts = {},
-- })

table.insert(M, {
    "echasnovski/mini.comment",
    event = "BufEnter",
    opts = {},
})

table.insert(M, {
    "echasnovski/mini.surround",
    event = "BufEnter",
    opts = {
        mappings = {
            add = "ys", -- Add surrounding in Normal and Visual modes
            delete = "ds", -- Delete surrounding
            find = "gsf", -- Find surrounding (to the right)
            find_left = "gsF", -- Find surrounding (to the left)
            highlight = "gsh", -- Highlight surrounding
            replace = "cs", -- Replace surrounding
            update_n_lines = "gsn", -- Update `n_lines`

            suffix_last = "l", -- Suffix to search with "prev" method
            suffix_next = "n", -- Suffix to search with "next" method
        },
    },
})

table.insert(M, {
    "echasnovski/mini.bracketed",
    event = "BufEnter",
    opts = {},
})

return M
