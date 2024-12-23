return {
    {
        "leoluz/nvim-dap-go",
        ft = "go",
        dependencies = "mfussenegger/nvim-dap",
        config = function(_, opts)
            require("dap-go").setup(opts)
            vim.keymap.set("n", "<localleader>dgt", function()
                require('dap-go').debug_test()
            end, { desc = "Debug: Go Test" })
            vim.keymap.set("n", "<localleader>dgl", function()
                require('dap-go').debug_last()
            end, { desc = "Debug: Last Go Test" })
        end
    },
    {
        "olexsmir/gopher.nvim",
        ft = "go",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "mfussenegger/nvim-dap",
        },
        -- (optional) will update plugin's deps on every update
        build = function()
            vim.cmd.GoInstallDeps()
        end,
        ---@type gopher.Config
        opts = {},
        config = function(_, opts)
            require('gopher').setup(opts)
            vim.keymap.set("n", "<localleader>gct", "<cmd>GoTestAdd<cr>",
                { desc = "go: [c]reate [t]ests for method under cursor" })
            vim.keymap.set("n", "<localleader>gca", "<cmd>GoTestsAll<cr>",
                { desc = "go: [c]reate tests for [a]ll methods in current file" })
            vim.keymap.set("n", "<localleader>gce", "<cmd>GoTestsExp<cr>",
                { desc = "go: [c]reate tests for all [e]xported methods" })
        end
    },
    {
        "ray-x/go.nvim",
        dependencies = { -- optional packages
            "ray-x/guihua.lua",
            "neovim/nvim-lspconfig",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("go").setup()
            vim.keymap.set("n", "<leader>ie", "<cmd>GoIfErr<cr>", { desc = "go: [i]nsert if[e]rr block" })
            vim.keymap.set("n", "<leader>isj", "<cmd>GoAddTag json<cr>", { desc = "go: [i]nsert [j]son [s]truct tags" })
            vim.keymap.set("n", "<leader>isy", "<cmd>GoAddTag yaml<cr>", { desc = "go: [i]nsert [y]aml [s]truct tags" })
            vim.keymap.set("n", "<localleader>gfs", "<cmd>GoFillStruct<cr>", { desc = "go: auto[f]ill [s]truct" })
            vim.keymap.set("n", "<localleader>gfS", "<cmd>GoFillSwitch<cr>", { desc = "go: auto[f]ill [S]witch" })
            vim.keymap.set("n", "<localleader>gfp", "<cmd>GoFixPlurals<cr>", { desc = "go: [f]ix [p]lurals" })
            vim.keymap.set("n", "<localleader>ga", "<cmd>GoAlt<cr>", { desc = "go: goto [a]lternate" })
        end,
        event = { "CmdlineEnter" },
        ft = { "go", 'gomod' },
        build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
    }
}
