return {
    "chrishrb/gx.nvim",
    keys = {
        { "gx", "<cmd>Browse<CR>", mode = { "n", "x" }, desc = "open link" },
    },
    cmd = { "Browse" },
    init = function()
        vim.g.netrw_nogx = 1
    end,
    dependencies = {
        { "nvim-lua/plenary.nvim" },
    },
    opts = {},
    submodules = false,
}
