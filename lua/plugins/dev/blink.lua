return {
    "saghen/blink.cmp",
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
                selection = "manual",
                draw = function(ctx)
                    local icon = ctx.kind_icon
                    local icon_hl = vim.api.nvim_get_hl(0, {
                        name = "BlinkCmpKind" .. ctx.kind
                    }) and "BlinkCmpKind" .. ctx.kind or "BlinkCmpKind"

                    -- local source, client = ctx.item.source_id, ctx.item.client_id
                    -- if client and vim.lsp.get_client_by_id(client).name then
                    --     source = vim.lsp.get_client_by_id(client)
                    --         .name
                    -- end

                    return {
                        {
                            icon .. ctx.icon_gap .. string.lower(ctx.kind) .. " ",
                            fill = true,
                            hl_group = icon_hl,
                            max_width = 25,
                        },
                        {
                            " " .. ctx.item.label .. " ",
                            fill = true,
                            hl_group = ctx.deprecated and "BlinkCmpLabelDeprecated" or "BlinkCmpLabel",
                            max_width = 35,
                        },
                        -- {
                        --     " <" .. string.lower(source) .. "> ",
                        --     fill = true,
                        --     hl_group = ctx.deprecated and "BlinkCmpLabelDeprecated" or "CmpItemMenu",
                        --     max_width = 15,
                        -- }
                    }
                end
            }
        },
        kind_icons = v.ui.icons.vscode,
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
