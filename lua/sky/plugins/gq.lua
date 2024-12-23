return {
    "paulshuker/textangle.nvim",
    -- Use only releases (optional).
    version = "*",
    opts = {},
    keys = {
        { "gk", "<cmd>TextangleLine<cr>", mode = "n", desc = "format line with textangle", noremap = true },
        {
            "gk",
            '<cmd>lua require("textangle").format_visual_line()<cr>',
            mode = "c",
            desc = "format with textangle",
            noremap = true,
        },
    },
}
