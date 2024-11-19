return {
    "nvim-telescope/telescope.nvim",
    lazy = false,
    dependencies = {
        "nvim-lua/plenary.nvim"
    },
    opts = {
        defaults = {
            mappings = {
                i = {
                    ["<M-j>"] = prequire('telescope.actions').move_selection_next,
                    ["<M-k>"] = prequire('telescope.actions').move_selection_previous,
                }
            }
        }
    },
    keys = {
        { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "[f]ind [f]iles" },
        { "<leader>fg", "<cmd>Telescope live_grep<cr>",  desc = "[f]ile [g]rep" },
        { "<leader>fh", "<cmd>Telescope help_tags<cr>",  desc = "[f]ind [h]elp" },
    }
}
