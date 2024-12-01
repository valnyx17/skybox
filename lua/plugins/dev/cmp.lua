return {
    "iguanacucumber/magazine.nvim",
    name = "nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
        { "iguanacucumber/mag-nvim-lsp",                         name = "cmp-nvim-lsp", opts = {} },
        { "iguanacucumber/mag-nvim-lua",                         name = "cmp-nvim-lua" },
        { "iguanacucumber/mag-buffer",                           name = "cmp-buffer" },
        { "iguanacucumber/mag-cmdline",                          name = "cmp-cmdline" },
        { "dmitmel/cmp-cmdline-history" },
        { url = "https://codeberg.org/FelipeLema/cmp-async-path" }, -- better than cmp-path
        {
            "folke/lazydev.nvim",
            dependencies = {
                "Bilal2453/luvit-meta"
            },
            opts = {
                library = {
                    "lazy.nvim",
                    { path = "luvit-meta/library", words = { "vim%.uv" } }
                }
            }
        },
        {
            "L3MON4D3/LuaSnip",
            build = (function()
                -- Build Step is needed for regex support in snippets.
                -- This step is not supported in many windows environments.
                -- Remove the below condition to re-enable on windows.
                if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
                    return
                end
                return 'make install_jsregexp'
            end)(),
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
        "saadparwaiz1/cmp_luasnip",
        "lukas-reineke/cmp-rg",
    },
    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")

        local sources = {
            { name = "nvim_lsp",                group_index = 1, priority = 500 },
            { name = 'nvim_lsp_signature_help', group_index = 1, priority = 500 },
            { name = "luasnip",                 priority = 1000 },
            { name = "lazydev",                 group_index = 1, priority = 1000 },
            { name = "buffer",                  group_index = 2, priority = 1000 },
            { name = "async_path",              group_index = 2, priority = 300 },
            { name = "rg",                      group_index = 2, keyword_length = 3, priority = 400 },
        }

        local winhighlight = table.concat({
            "Normal:NormalFloat",
            "FloatBorder:FloatBorder",
            "CursorLine:Visual",
            "Search:None",
        }, ",")

        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            preselect = cmp.PreselectMode.None,
            performance = {
                debounce = 0,
                throttle = 0,
            },
            completion = { completeopt = 'menu,menuone,noselect' },
            window = {
                completion = {
                    winhighlight = winhighlight,
                    zindex = 1001,
                    col_offset = 0,
                    border = v.ui.borders.empty,
                    side_padding = 1,
                    scrollbar = false,
                },
                documentation = {
                    border = v.ui.borders.empty,
                    winhighlight = winhighlight,
                },
            },
            formatting = {
                expandable_indicator = true,
                deprecated = true,
                fields = { 'abbr', 'kind', 'menu' },
                ellipsis_char = v.ui.icons.ellipsis,
                format = function(entry, vim_item)
                    local item_maxwidth = 30
                    local ellipsis_char = v.ui.icons.ellipsis

                    ---@param item string
                    ---@return string limited string
                    local function truncate(item)
                        if item ~= nil and item:len() > item_maxwidth then
                            item = item:sub(0, item_maxwidth) .. ellipsis_char
                            return item
                        end
                        return item
                    end

                    if entry.source.name == "async_path" then
                        local icon, hl_group = require("nvim-web-devicons").get_icon(entry:get_completion_item().label)
                        if icon then
                            vim_item.kind = icon
                            vim_item.kind_hl_group = hl_group
                            return vim_item
                        end
                    end

                    if entry.source.name == "nvim_lsp_signature_help" then
                        local parts = vim.split(vim_item.abbr, " ", {})
                        local argument = parts[1]
                        argument = argument:gsub(":$", "")
                        local type = table.concat(parts, " ", 2)
                        vim_item.abbr = argument
                        if type ~= nil and type ~= "" then
                            local icon = v.ui.icons.vscode[type]
                            if icon ~= nil then
                                vim_item.kind = icon
                            else
                                vim_item.kind = ""
                            end
                            vim_item.menu = type
                        end
                        -- vim_item.kind_hl_group = "Type"
                        vim_item.menu_hl_group = "Type"
                    end

                    local colors_icon = "󱓻"
                    local entryItem = entry:get_completion_item()
                    local color = entryItem.documentation

                    if color and type(color) == "string" and color:match("^#%x%x%x%x%x%x$") then
                        local hl = "hex-" .. color:sub(2)

                        if #vim.api.nvim_get_hl(0, { name = hl }) == 0 then vim.api.nvim_set_hl(0, hl, { fg = color }) end

                        vim_item.kind = " " .. colors_icon
                        vim_item.kind_hl_group = hl
                        vim_item.menu_hl_group = hl
                    else
                        vim_item.kind = string.format("%s %s", v.ui.icons.kind[vim_item.kind], vim_item.kind)
                    end

                    vim_item.menu = truncate(vim_item.menu)
                    vim_item.abbr = truncate(vim_item.abbr)

                    if entry.source.name == "nvim_lsp" then
                        vim_item.menu = string.format("[%s]", entry.source.source.client.name)
                    else
                        vim_item.menu = ({
                            nvim_lsp = "[lsp]",
                            luasnip = "[lsnip]",
                            vsnip = "[vsnip]",
                            snippets = "[snips]",
                            nvim_lua = "[nlua]",
                            nvim_lsp_signature_help = "[sig]",
                            async_path = "[path]",
                            git = "[git]",
                            tmux = "[tmux]",
                            rg = "[rg]",
                            fuzzy_buffer = "[buf]",
                            buffer = "[buf]",
                            spell = "[spl]",
                            neorg = "[neorg]",
                            cmdline = "[cmd]",
                            cmdline_history = "[cmdhist]",
                            emoji = "[emo]",
                        })[entry.source.name] or entry.source.name
                    end

                    return vim_item
                end
            },
            sources = sources,
            mapping = cmp.mapping.preset.insert {
                -- select next.
                ['<M-j>'] = cmp.mapping(function(fallback)
                    if luasnip.choice_active() then
                        luasnip.change_choice(1)
                    elseif cmp.visible() then
                        cmp.select_next_item()
                    else
                        fallback()
                    end
                end),
                -- select prev.
                ['<M-k>'] = cmp.mapping(function(fallback)
                    if luasnip.choice_active() then
                        luasnip.change_choice(-1)
                    elseif cmp.visible() then
                        cmp.select_prev_item()
                    else
                        fallback()
                    end
                end),
                --  scroll up.
                ['<M-u>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.scroll_docs(-4)
                    else
                        fallback()
                    end
                end),
                -- scroll down.
                ['<M-d>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.scroll_docs(4)
                    else
                        fallback()
                    end
                end),
                ['<M-i>'] = cmp.mapping.confirm { select = true },
                ['<C-e>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.close()
                    else
                        fallback()
                    end
                end),
                -- TODO: Show/Hide documentation.
                ['<M-c>'] = cmp.mapping.complete {},
                ['<M-l>'] = cmp.mapping(function()
                    if luasnip.expand_or_locally_jumpable() then
                        luasnip.expand_or_jump()
                    end
                end, { 'i', 's' }),
                ['<M-h>'] = cmp.mapping(function()
                    if luasnip.locally_jumpable(-1) then
                        luasnip.jump(-1)
                    end
                end, { 'i', 's' }),
            }
        })

        cmp.setup.cmdline({ "/", "?" }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = "nvim_lsp_document_symbol" },
                { name = "rg",                      min_match_length = 3, max_item_count = 5 },
                { name = "buffer",                  min_match_length = 2, max_item_count = 5 },
            },
        })

        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            enabled = function()
                local disabled = {
                    IncRename = true
                }

                -- get first word of cmdline
                local cmd = vim.fn.getcmdline():match("%S+")
                -- return true if cmd is not in disabled list
                -- else call/return cmp.close(), which returns false
                return not disabled[cmd] or cmp.close()
            end,
            sources = cmp.config.sources({
                    { name = "async_path", }
                },
                {
                    {
                        name = "cmdline",
                        group_index = 2,
                        keyword_length = 2,
                        max_item_count = 5,
                        ignore_cmds = {},
                        -- ignore_cmds = { "Man", "!" },
                        keyword_pattern = [=[[^[:blank:]\!]*]=],
                    },
                    {
                        name = "cmdline_history",
                        group_index = 2,
                        keyword_length = 2,
                        max_item_count = 5,
                        ignore_cmds = {},
                        -- ignore_cmds = { "Man", "!" },
                        keyword_pattern = [=[[^[:blank:]\!]*]=],
                    },
                }),
        })

        if pcall(require, "nvim-autopairs") then
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end

        -- Override the documentation handler to remove the redundant detail section.
        ---@diagnostic disable-next-line: duplicate-set-field
        require("cmp.entry").get_documentation = function(self)
            local item = self.completion_item

            if item.documentation then return vim.lsp.util.convert_input_to_markdown_lines(item.documentation) end

            -- Use the item's detail as a fallback if there's no documentation.
            if item.detail then
                local ft = self.context.filetype
                local dot_index = string.find(ft, "%.")
                if dot_index ~= nil then ft = string.sub(ft, 0, dot_index - 1) end
                return (vim.split(("```%s\n%s```"):format(ft, vim.trim(item.detail)), "\n"))
            end

            return {}
        end
    end
}
