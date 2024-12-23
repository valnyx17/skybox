return {
    {
        "nvim-treesitter/nvim-treesitter",
        module = "nvim-treesitter",
        build = ":TSUpdate",
        event = { "VeryLazy" },
        dependencies = {
            "JoosepAlviste/nvim-ts-context-commentstring",
        },
        opts = {
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },

            indent = {
                enable = true,
            },
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
    },
    {
        "Wansmer/treesj",
        event = "BufEnter",
        keys = { 'gJ' },
        config = function()
            vim.keymap.set("n", "gJ", "<cmd>lua require('treesj').toggle()<cr>", { desc = "treesj join", noremap = true })
        end,
    },
    {
        "danymat/neogen",
        event = "BufEnter",
        dependencies = "nvim-treesitter/nvim-treesitter",
        opts = {
            languages = {
                lua = {
                    template = {
                        annotation_convention = "ldoc",
                    },
                },
                python = {
                    template = {
                        annotation_convention = "numpydoc",
                    },
                },
            },
        },
        config = function(_, opts)
            prequire("neogen").setup(opts)
            vim.keymap.set("n", "<leader>id", require('neogen').generate, { desc = "[i]nsert [d]ocumentation (neogen)" })
        end,
    },

    -- Treesitter context
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = "BufEnter",
        opts = { mode = "cursor", max_lines = 2 },
    },

    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        event = "VeryLazy",
        config = function()
            require("nvim-treesitter.configs").setup({
                highlight = { enable = true },
                indent = { enable = true },
                textobjects = {
                    select = {
                        enable = true,
                        lookhead = true,
                        keymaps = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["aa"] = "@parameter.outer",
                            ["ia"] = "@parameter.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                            ["ii"] = "@conditional.inner",
                            ["ai"] = "@conditional.outer",
                            ["at"] = "@comment.outer",
                            ["iq"] = "@block.innter",
                        },
                    },
                },
            })
        end,
    },
}
