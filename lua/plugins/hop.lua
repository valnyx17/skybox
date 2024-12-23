return {
    "smoka7/hop.nvim",
    opts = {
        keys = "etovxqpdygfblzhckisuran",
        multi_windows = true,
    },
    config = function(_, opts)
        prequire("hop").setup(opts)

        local hop = require("hop")
        local directions = require("hop.hint").HintDirection

        vim.keymap.set({ "n", "x", "o" }, ";", function()
            hop.hint_words({})
        end, { desc = "hop words" })
        vim.keymap.set({ "n", "x", "o" }, ";n", function()
            require("hop-treesitter").hint_nodes()
        end, { desc = "hop nodes" })
        vim.keymap.set("", "f", function()
            hop.hint_char1({
                direction = directions.AFTER_CURSOR,
                current_line_only = true,
            })
        end)
        vim.keymap.set("", "F", function()
            hop.hint_char1({
                direction = directions.BEFORE_CURSOR,
                current_line_only = true,
            })
        end)
        vim.keymap.set("", "t", function()
            hop.hint_char1({
                direction = directions.AFTER_CURSOR,
                current_line_only = true,
                hint_offset = -1,
            })
        end)
        vim.keymap.set("", "T", function()
            hop.hint_char1({
                direction = directions.BEFORE_CURSOR,
                current_line_only = true,
                hint_offset = -1,
            })
        end)
    end
}
