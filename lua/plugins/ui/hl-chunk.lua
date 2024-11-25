return {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        chunk = {
            enable = true,
            chars = {
                right_arrow = "▶",
            },
            style = {
                vim.api.nvim_get_hl(0, { name = "Whitespace" }),
                vim.api.nvim_get_hl(0, { name = "Error" })
            }
        },
        indent = {
            enable = false
        },
        line_num = {
            enable = false
        },
        blank = {
            enable = false
        }
    }
}
