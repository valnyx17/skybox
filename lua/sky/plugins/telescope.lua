return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    opts = {
        defaults = {
            entry_prefix = "  ",
            prompt_prefix = "   ",
            selection_caret = "  ",
            color_devicons = true,
            path_display = { "smart" },
            dynamic_preview_title = true,
            borderchars = {
                prompt = sky.ui.borders.empty,
                results = sky.ui.borders.empty,
                preview = sky.ui.borders.empty,
            },

            sorting_strategy = "ascending",
            layout_strategy = "horizontal",
            layout_config = {
                horizontal = {
                    height = 0.95,
                    preview_width = 0.55,
                    prompt_position = "top",
                    width = 0.9,
                },
                center = {
                    anchor = "N",
                    width = 0.9,
                    preview_cutoff = 10,
                },
                vertical = {
                    height = 0.9,
                    preview_height = 0.3,
                    width = 0.9,
                    preview_cutoff = 10,
                    prompt_position = "top",
                },
            },
            mappings = {
                i = {
                    ["<M-j>"] = prequire('telescope.actions').move_selection_next,
                    ["<M-k>"] = prequire('telescope.actions').move_selection_previous,
                },
            },
        },
        extensions = {
            persisted = {
                layout_config = {
                    width = 0.55,
                    height = 0.55,
                },
            },
        },
    },
    keys = {
        { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "[f]ind [f]iles" },
        { "<leader>fg", "<cmd>Telescope live_grep<cr>",  desc = "[f]ile [g]rep" },
        { "<leader>fh", "<cmd>Telescope help_tags<cr>",  desc = "[f]ind [h]elp" },
    },
}
