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
                disable = function(lang, buf)
                    local max_filesize = 100 * 1024 -- 100KB
                    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        return true
                    end
                end,
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
        keys = { "gJ" },
        config = function()
            require("legendary").keymap({
                "gJ",
                function()
                    require("treesj").toggle()
                end,
                description = "treesj join",
                opts = {
                    noremap = true,
                },
            })
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
            require("legendary").keymap({
                "<leader>id",
                require("neogen").generate,
                description = "[i]nsert [d]ocumentation (neogen)",
            })
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
