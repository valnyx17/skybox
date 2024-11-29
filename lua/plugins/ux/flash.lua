return {
    "folke/flash.nvim",
    event = "VeryLazy",
    dependencies = {
        "declancm/cinnamon.nvim",
    },
    ---@type Flash.Config
    opts = {
        modes = {
            char = {
                jump_labels = true
            }
        },
        action = function(match, state)
            local jump = require("flash.jump")
            require("cinnamon").scroll(function()
                jump.jump(match, state)
                jump.on_jump(state)
            end)
        end,
        labels = "etovxqpdygfblzhckisuran",
    },
    -- stylua: ignore
    keys = {
        { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
        { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
        { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
        { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
        { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    }
}
