local detail = false
return {
    "stevearc/oil.nvim",
    ---@module oil
    ---@type oil.SetupOpts
    opts = {
        view_options = {
            show_hidden = true,
        },
        default_file_explorer = false,
        skip_confirm_for_simple_edits = true,
        keymaps = {
            ["gd"] = {
                desc = "Toggle file detail view",
                callback = function()
                    detail = not detail
                    if detail then
                        require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
                    else
                        require("oil").set_columns({ "icon" })
                    end
                end,
            },
            ["<C-s>"] = {},
            ["<C-v>"] = {
                "actions.select",
                opts = { vertical = true },
            },
        },
    },
    keys = {
        { "<leader>fd", "<cmd>Oil<cr>", desc = "find file (dired)" },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
}
