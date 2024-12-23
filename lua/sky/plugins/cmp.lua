local winhighlight = table.concat({
    "Normal:BlinkCmpMenu",
    -- "Normal:NormalFloat",
    "FloatBorder:BlinkCmpMenuBorder",
    "CursorLine:PmenuMatchSel",
    "Search:None",
}, ",")

return {
    {
        "folke/lazydev.nvim",
        ft = "lua",
        cmd = "LazyDev",
        dependencies = {
            "Bilal2453/luvit-meta",
        },
        opts = {
            library = {
                "lazy.nvim",
                { path = "luvit-meta/library", words = { "vim%.uv" } },
                {
                    path = "/run/current-system/sw/share/awesome/lib",
                    mods = { "awful", "beautiful", "gears", "menubar", "naughty", "wibox", "awesome" },
                },
                { path = "snacks.nvim",        words = { "Snacks" } },
            },
        },
    },
    {
        "kristijanhusak/vim-dadbod-ui",
        dependencies = {
            { "tpope/vim-dadbod",                     lazy = true },
            { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
        },
        cmd = {
            "DBUI",
            "DBUIToggle",
            "DBUIAddConnection",
            "DBUIFindBuffer",
        },
        init = function()
            -- Your DBUI configuration
            vim.g.db_ui_use_nerd_fonts = 1
        end,
    },
    {
        "saghen/blink.cmp",
        dependencies = {
            {
                "L3MON4D3/LuaSnip",
                build = (function()
                    -- Build Step is needed for regex support in snippets.
                    -- This step is not supported in many windows environments.
                    -- Remove the below condition to re-enable on windows.
                    if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
                        return
                    end
                    return "make install_jsregexp"
                end)(),
                dependencies = {
                    {
                        "rafamadriz/friendly-snippets",
                        config = function()
                            require("luasnip.loaders.from_vscode").lazy_load()
                        end,
                    },
                },
                opts = {
                    history = true,
                    delete_check_events = "TextChanged",
                },
                config = function(_, opts)
                    require("luasnip").setup(opts)
                    require("luasnip.loaders.from_lua").load({
                        paths = {
                            vim.fn.stdpath("config") .. "/snippets",
                        },
                    })
                end,
            },
            {
                "giuxtaposition/blink-cmp-copilot",
                dependencies = {
                    {
                        "zbirenbaum/copilot.lua",
                        event = "InsertEnter",
                        opts = {
                            panel = { enabled = false },
                            suggestion = { enabled = false },
                            filetypes = {
                                markdown = true,
                                help = true,
                                ["grug-far"] = false,
                                ["grug-far-history"] = false,
                            },
                        },
                    },
                },
            },
        },
        version = "*",
        build = "nix run .#build-plugin",
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            sources = {
                default = { "lsp", "lazydev", "path", "snippets", "buffer", "copilot", "luasnip", "dadbod" },
                cmdline = function()
                    local type = vim.fn.getcmdtype()

                    if type == "/" or type == "?" then
                        return { "buffer" }
                    end
                    if type == ":" then
                        return { "cmdline" }
                    end
                    return {}
                end,
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        enabled = true,
                        module = "lazydev.integrations.blink",
                        score_offset = 1010,
                        max_items = 10,
                    },
                    lsp = {
                        name = "lsp",
                        enabled = true,
                        module = "blink.cmp.sources.lsp",
                        -- kind = "LSP",
                        score_offset = 1000, -- higher number = higher priority
                        max_items = 10,
                    },
                    luasnip = {
                        name = "luasnip",
                        enabled = true,
                        module = "blink.cmp.sources.luasnip",
                        score_offset = 950,
                        max_items = 5,
                    },
                    snippets = {
                        name = "snippets",
                        enabled = true,
                        module = "blink.cmp.sources.snippets",
                        score_offset = 900,
                        max_items = 5,
                    },
                    dadbod = {
                        name = "dadbod",
                        module = "vim_dadbod_completion.blink",
                        score_offset = 950,
                    },
                    -- third class citizen mf always talking shit
                    copilot = {
                        name = "copilot",
                        enabled = true,
                        module = "blink-cmp-copilot",
                        -- kind = "Copilot",
                        score_offset = -100,
                        async = true,
                    },
                },
            },
            snippets = {
                expand = function(snippet)
                    require("luasnip").lsp_expand(snippet)
                end,
                active = function(filter)
                    if filter and filter.direction then
                        return require("luasnip").jumpable(filter.direction)
                    end
                    return require("luasnip").in_snippet()
                end,
                jump = function(direction)
                    require("luasnip").jump(direction)
                end,
            },
            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = "normal",
            },
            keymap = {
                ["<M-j>"] = {
                    function()
                        if require("luasnip").choice_active() then
                            require("luasnip").change_choice(1)
                            return true
                        end
                    end,
                    "select_next",
                    "fallback",
                },
                ["<M-k>"] = {
                    function()
                        if require("luasnip").choice_active() then
                            require("luasnip").change_choice(-1)
                            return true
                        end
                    end,
                    "select_prev",
                    "fallback",
                },
                ["<M-u>"] = { "scroll_documentation_up", "fallback" },
                ["<M-d>"] = { "scroll_documentation_down", "fallback" },
                ["<M-i>"] = { "select_and_accept" },
                ["<C-e>"] = { "hide", "fallback" },
                ["<M-c>"] = { "show", "show_documentation", "hide_documentation", "fallback" },
                ["<M-l>"] = { "snippet_forward", "fallback" },
                ["<M-h>"] = { "snippet_backward", "fallback" },
                ["<A-1>"] = {
                    function(cmp)
                        cmp.accept({ index = 1 })
                    end,
                },
                ["<A-2>"] = {
                    function(cmp)
                        cmp.accept({ index = 2 })
                    end,
                },
                ["<A-3>"] = {
                    function(cmp)
                        cmp.accept({ index = 3 })
                    end,
                },
                ["<A-4>"] = {
                    function(cmp)
                        cmp.accept({ index = 4 })
                    end,
                },
                ["<A-5>"] = {
                    function(cmp)
                        cmp.accept({ index = 5 })
                    end,
                },
                ["<A-6>"] = {
                    function(cmp)
                        cmp.accept({ index = 6 })
                    end,
                },
                ["<A-7>"] = {
                    function(cmp)
                        cmp.accept({ index = 7 })
                    end,
                },
                ["<A-8>"] = {
                    function(cmp)
                        cmp.accept({ index = 8 })
                    end,
                },
                ["<A-9>"] = {
                    function(cmp)
                        cmp.accept({ index = 9 })
                    end,
                },
                ["<A-0>"] = {
                    function(cmp)
                        cmp.accept({ index = 10 })
                    end,
                },
            },
            signature = { enabled = true },
            completion = {
                menu = {
                    winhighlight = winhighlight,
                    min_width = 10,
                    -- winblend = 25,
                    scrollbar = false,
                    draw = {
                        align_to_component = "label",
                        padding = 1,
                        gap = 1,
                        components = {
                            kind = {
                                width = { fill = false },
                            },
                        },
                        columns = {
                            { "label" },
                            { "kind_icon",  "kind", gap = 1 },
                            { "source_name" },
                        },
                    },
                },
                keyword = {
                    range = "full",
                },
                list = {
                    selection = "preselect",
                },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 0,
                    window = {
                        -- winblend = 25,
                        winhighlight = winhighlight,
                    },
                },
            },
        },
    },
}
