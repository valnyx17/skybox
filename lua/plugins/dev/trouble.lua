return {
    "folke/trouble.nvim",
    opts = {},
    cmd = "Trouble",
    keys = {
        {
            "<leader>xx",
            "<cmd>Trouble diagnostics toggle<cr>",
            desc = "Diagnostics (Trouble)",
        },
        {
            "<leader>xX",
            "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
            desc = "Buffer Diagnostics (Trouble)",
        },
        {
            "<leader>ls",
            "<cmd>Trouble symbols toggle focus=false<cr>",
            desc = "Symbols (Trouble)",
        },
        -- {
        --     "<leader>ld",
        --     "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        --     desc = "LSP Definitions / references / ... (Trouble)",
        -- },
        {
            "<leader>xl",
            "<cmd>Trouble loclist toggle<cr>",
            desc = "Location List (Trouble)",
        },
        {
            "<leader>lq",
            "<cmd>Trouble qflist toggle<cr>",
            desc = "[q]uickfix [l]ist (Trouble)",
        },
    },
}
