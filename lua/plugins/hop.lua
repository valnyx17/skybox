prequire("hop").setup({
    keys = "etovxqpdygfblzhckisuran",
})
local hop = require("hop")
local directions = require("hop.hint").HintDirection

vim.keymap.set({ "n", "x", "o" }, "s", "<cmd>HopWord<CR>", { desc = "hop words" })
vim.keymap.set({ "n", "x", "o" }, "S", "<cmd>HopNodes<CR>", { desc = "hop nodes" })
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
