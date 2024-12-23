return {
    "mrjones2014/legendary.nvim",
    priority = 10000,
    lazy = false,
    opts = {
        extensions = {
            lazy_nvim = true,
        },
    },
    keys = {
        { "<leader><leader>", "<cmd>Legendary<cr>", desc = "Open Legendary" },
    },
}
