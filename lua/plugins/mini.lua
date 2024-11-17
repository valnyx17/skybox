prequire('mini.ai').setup()

prequire('mini.move').setup()

prequire('mini.align').setup()

-- if not vim.g.neovide then
--     prequire('mini.animate').setup()
-- end

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

prequire('mini.files').setup()

vim.keymap.set("n", "<leader>fe", function()
    MiniFiles.open()
end, { desc = "open minifiles" })

prequire('mini.surround').setup({
    mappings = {
        add = 'ys',            -- Add surrounding in Normal and Visual modes
        delete = 'ds',         -- Delete surrounding
        find = 'sf',           -- Find surrounding (to the right)
        find_left = 'sF',      -- Find surrounding (to the left)
        highlight = 'sh',      -- Highlight surrounding
        replace = 'cs',        -- Replace surrounding
        update_n_lines = 'sn', -- Update `n_lines`

        suffix_last = 'l',     -- Suffix to search with "prev" method
        suffix_next = 'n',     -- Suffix to search with "next" method
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
