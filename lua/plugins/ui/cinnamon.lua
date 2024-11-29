return {
    "declancm/cinnamon.nvim",
    version = "*",
    opts = {
        disabled = false,
        keymaps = {
            basic = true,
            extra = true,
        }
    },
    config = function(_, opts)
        local cinnamon = require("cinnamon")
        cinnamon.setup(opts)

        -- centered scrolling
        vim.keymap.set("n", "<C-u>", function() cinnamon.scroll("<C-u>zz") end, { silent = true, noremap = true })
        vim.keymap.set("n", "<C-d>", function() cinnamon.scroll("<C-d>zz") end, { silent = true, noremap = true })
        vim.keymap.set("n", "n", function() cinnamon.scroll("nzz") end, { silent = true, noremap = true })
        vim.keymap.set("n", "N", function() cinnamon.scroll("Nzz") end, { silent = true, noremap = true })
        vim.keymap.set("n", "*", function() cinnamon.scroll("*zz") end, { silent = true, noremap = true })
        vim.keymap.set("n", "#", function() cinnamon.scroll("#zz") end, { silent = true, noremap = true })
        vim.keymap.set("n", "g*", function() cinnamon.scroll("g*zz") end, { silent = true, noremap = true })
        vim.keymap.set("n", "g#", function() cinnamon.scroll("g#zz") end, { silent = true, noremap = true })
    end
}
