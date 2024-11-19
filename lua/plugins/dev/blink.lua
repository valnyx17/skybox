return {
    "saghen/blink.cmp",
    lazy = false,
    version = "v0.5.1",
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
        }
    },
    opts = {
        fuzzy = {
            prebuilt_binaries = {
                force_version = "v0.5.1"
            }
        },
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

        highlight = {
            use_nvim_cmp_as_default = true,
        },
        nerd_font_variant = "mono",
        sources = {
            completion = {
                enabled_providers = { "lsp", "path", "snippets", "buffer", "lazydev" }
            },
            providers = {
                lsp = {
                    -- don't show LuaLS require statements when lazydev has items
                    fallback_for = { "lazydev" }
                },
                lazydev = {
                    name = "LazyDev",
                    module = "lazydev.integrations.blink"
                }
            }
        }
    }
}
