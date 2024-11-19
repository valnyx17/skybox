return {
    "NvChad/nvim-colorizer.lua",
    opts = {
        user_default_options = {
            css = true,
            virtualtext = "■",
            names = false,
        },
        filetypes = {
            "*",
            "!prompt",
            "!popup",
            html = { mode = "foreground" },
            cmp_docs = { always_update = true },
            css = { names = true },
        },
    }
}
