return {
    "stevearc/quicker.nvim",
    event = "FileType qf",
    keys = {
        {
            "<leader>lq",
            function()
                require("quicker").toggle()
            end,
            desc = "toggle [q]uickfix [l]ist",
        },
        {
            "<leader>ll",
            function()
                require("quicker").toggle({ loclist = true })
            end,
            desc = "toggle [l]ocation [l]ist",
        },
    },
    ---@module "quicker"
    ---@type quicker.SetupOptions
    opts = {
        keys = {
            {
                ">",
                function()
                    require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
                end,
                desc = "Expand quickfix context",
            },
            {
                "<",
                function()
                    require("quicker").collapse()
                end,
                desc = "Collapse quickfix context",
            },
        },
    },
}
