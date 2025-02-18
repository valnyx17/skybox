return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = {
        {
            "<leader>?",
            function()
                require("which-key").show({ global = false })
            end,
            desc = "Buffer Local Keymaps (which-key)",
        },
        {
            "<c-w><space>",
            function()
                require("which-key").show({ keys = "<c-w>", loop = true })
            end,
            desc = "Window Hydra Mode (which-key)"
        }
    },
    opts = {
        delay = 150,
        preset = "helix",
        spec = {
            { "<leader>f",      group = "find" },
            { "<leader>l",      group = "lsp" },
            { "<leader>g",      group = "git" },
            { "<localleader>g", group = "go" },
            { "<leader>i",      group = "insert" },
            { "<leader>h",      group = "hunk" },
            { "<leader>s",      group = "search" },
            { "<leader>u",      group = "toggles" },
            { "<leader>e",      group = "edit" },
            { "<leader>t",      group = "test" },
            { "<leader>q",      group = "sessions" },
            { "<localleader>b", group = "buffer" },
            { "<localleader>d", group = "debug" },
            { "<localleader>h", group = "hunk" },
            { "<localleader>r", group = "repl" },
            { "<localleader>t", group = "tabs" },
            { "<localleader>s", group = "splits" },
            { "<localleader>p", group = "persistence" },
            {
                "<c-w>",
                group = "windows",
                expand = function()
                    return require('which-key.extras').expand.win()
                end
            }
        },
        icons = {
            mappings = false,
            breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
            -- separator = "➜", -- symbol used between a key and it's label
            separator = "->", -- symbol used between a key and it's label
            group = "+",      -- symbol prepended to a group
        },
        layout = { align = "center" },
        triggers = {
            { "<auto>", mode = "nso" },
        },
        plugins = {
            marks = true,     -- shows a list of your marks on ' and `
            registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
            -- the presets plugin, adds help for a bunch of default keybindings in Neovim
            -- No actual key bindings are created
            spelling = {
                enabled = true,   -- enabling this will show WhichKey when pressing z= to select spelling suggestions
                suggestions = 20, -- how many suggestions should be shown in the list?
            },
            presets = {
                operators = true,   -- adds help for operators like d, y, ... and registers them for motion / text object completion
                motions = false,     -- adds help for motions
                text_objects = true, -- help for text objects triggered after entering an operator
                windows = false,     -- default bindings on <c-w>
                nav = true,          -- misc bindings to work with windows
                z = true,            -- bindings for folds, spelling and others prefixed with z
                g = true,            -- bindings for prefixed with g
            },
        },
        replace = {
            -- override the label used to display some keys. It doesn't effect WK in any other way.
            -- For example:
            ["<space>"] = "SPC",
            ["<cr>"] = "RET",
            ["<tab>"] = "TAB",
        },
        win = { border = viv.ui.cur_border },
        show_help = true,
    },
    config = function(_, opts)
        local wk = require("which-key")
        vim.api.nvim_set_hl(0, "WhichKeyValue", { link = "NormalFloat" })
        vim.api.nvim_set_hl(0, "WhichKeyDesc", { link = "NormalFloat" })
        wk.setup(opts)
    end,
}
