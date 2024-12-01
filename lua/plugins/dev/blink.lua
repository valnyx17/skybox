return {
    "saghen/blink.cmp",
    enabled = false,
    version = "0.*",
    dependencies = {
        {
            "folke/lazydev.nvim",
            dependencies = {
                "Bilal2453/luvit-meta"
            },
            opts = {
                library = {
                    { path = "luvit-meta/library", words = { "vim%.uv" } }
                }
            }
        },
        {
            "L3MON4D3/LuaSnip",
            dependencies = {
                {
                    "rafamadriz/friendly-snippets",
                    config = function()
                        require("luasnip.loaders.from_vscode").lazy_load()
                    end
                }
            },
            opts = {
                history = true,
                delete_check_events = "TextChanged",
            },
            config = function(_, opts)
                require('luasnip').setup(opts)
                require("luasnip.loaders.from_lua").load({
                    paths = {
                        vim.fn.stdpath('config') .. "/snippets"
                    }
                })
            end
        },
        { "saghen/blink.compat", version = "*", opts = { impersonate_nvim_cmp = true } },
        "saadparwaiz1/cmp_luasnip"
    },
    opts = {
        keymap = {
            ["<M-c>"] = { "show", "show_documentation", "hide_documentation" },
            ["<C-e>"] = { "hide" },
            ["<M-i>"] = { "select_and_accept" },
            ["<M-j>"] = { "select_next", "fallback" },
            ["<M-k>"] = { "select_prev", "fallback" },
            ["<M-u>"] = { "scroll_documentation_up", "fallback" },
            ["<M-d>"] = { "scroll_documentation_down", "fallback" },
            ["<M-l>"] = { "snippet_forward", "fallback" },
            ["<M-h>"] = { "snippet_backward", "fallback" },
        },
        auto_brackets = {
            enabled = true
        },
        highlight = {
            use_nvim_cmp_as_default = true,
        },
        windows = {
            documentation = {
                border = v.ui.borders.empty,
                auto_show = true,
                auto_show_delay_ms = 0,
                update_delay_ms = 0,
                min_width = 15,
                max_width = 60,
                max_height = 20
            },
            signature_help = {
                border = v.ui.borders.empty
            },
            autocomplete = {
                min_width = 25,
                max_height = 30,
                scrollbar = true,
                border = v.ui.borders.empty,
            }
        },
        kind_icons = v.ui.icons.vscode,
        nerd_font_variant = "mono",
        sources = {
            completion = {
                enabled_providers = {
                    "lsp",
                    "path",
                    "luasnip",
                    "buffer",
                    "lazydev",
                }
            },
            providers = {
                lsp = {
                    -- don't show LuaLS require statements when lazydev has items
                    fallback_for = { "lazydev" }
                },
                lazydev = {
                    name = "LazyDev",
                    module = "lazydev.integrations.blink"
                },
                luasnip = {
                    name = "luasnip",
                    -- module = "blink_luasnip",
                    module = "blink.compat.source",

                    score_offset = -3,

                    opts = {
                        use_show_condition = false, -- disable filtering completion candidates
                        show_autosnippets = true
                    }
                }
            }
        },
        snippets = {
            expand = function(snippet) require('luasnip').lsp_expand(snippet) end,
            active = function(filter)
                if filter and filter.direction then
                    return require('luasnip').jumpable(filter.direction)
                end
                return require('luasnip').in_snippet()
            end,
            jump = function(direction) require('luasnip').jump(direction) end,
        }
    },
}
