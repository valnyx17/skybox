return {
    {
        "nvim-treesitter/nvim-treesitter",
        module = "nvim-treesitter",
        build = ":TSUpdate",
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
        "danymat/neogen",
        lazy = false,
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
            vim.keymap.set("n", "<leader>id", require('neogen').generate, { desc = "neogen generate" })
        end,
    },

    -- Treesitter context
    {
        "nvim-treesitter/nvim-treesitter-context",
        lazy = false,
        opts = { mode = "cursor", max_lines = 2 },
    },

    {
        "nvim-treesitter/nvim-treesitter-textobjects",
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
