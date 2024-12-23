return {
    "stevearc/dressing.nvim",
    events = "VeryLazy",
    opts = {
        input = {
            enabled = true,
            insert_only = false,
            start_in_insert = false,
            border = sky.ui.cur_border,
            prefer_width = 25,
            max_width = { 80, 0.5 },
            min_width = { 10, 0.2 },
        },
        select = {
            enabled = true,
            backend = {
                "telescope",
                "fzf_lua",
                "builtin",
            },
        },
    },
}
