return {
    {
        "ray-x/yamlmatter.nvim",
        cond = false,
        ft = { "markdown" },
        config = function()
            require("yamlmatter").setup({
                key_value_padding = 4, -- Default padding between key and value
                icon_mappings = {
                    -- Default icon mappings
                    title = "",
                    author = "",
                    date = "",
                    id = "",
                    tags = "",
                    category = "",
                    type = "",
                    default = "󰦨",
                },
                highlight_groups = {
                    -- icon = 'YamlFrontmatterIcon',
                    -- key = 'YamlFrontmatterKey',
                    -- value = 'YamlFrontmatterValue',
                    icon = "Identifier",
                    key = "Function",
                    value = "Type",
                },
            })
        end,
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown" },
        opts = {
            heading = {
                -- Turn on / off heading icon & background rendering
                enabled = true,
                -- Turn on / off any sign column related rendering
                sign = false,
                -- Replaces '#+' of 'atx_h._marker'
                -- The number of '#' in the heading determines the 'level'
                -- The 'level' is used to index into the array using a cycle
                -- The result is left padded with spaces to hide any additional '#'
                icons = { "󰉫 ", "󰉬 ", "󰉭 ", "󰉮 ", "󰉯 ", "󰉰 " },
                -- icons = { "󰉫 ", "󰉬 ", "󰉭 ", "󰉮 ", "󰉯 ", "󰉰 " },
                -- icons = { "󰼏 ", "󰎨 " },
                -- icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
                -- Added to the sign column if enabled
                -- The 'level' is used to index into the array using a cycle
                signs = { "󰫎 " },
                -- The 'level' is used to index into the array using a clamp
                -- Highlight for the heading icon and extends through the entire line
                backgrounds = {
                    "RenderMarkdownH1Bg",
                    "RenderMarkdownH2Bg",
                    "RenderMarkdownH3Bg",
                    "RenderMarkdownH4Bg",
                    "RenderMarkdownH5Bg",
                    "RenderMarkdownH6Bg",
                },
                -- The 'level' is used to index into the array using a clamp
                -- Highlight for the heading and sign icons
                foregrounds = {
                    "RenderMarkdownH1",
                    "RenderMarkdownH2",
                    "RenderMarkdownH3",
                    "RenderMarkdownH4",
                    "RenderMarkdownH5",
                    "RenderMarkdownH6",
                },
                -- Used above heading for border
                -- above = "▄",
                -- Used below heading for border
                -- below = "▀",
                -- border = true,
                -- width = { "full", "full", "block", "block", "block" },
                width = { "full", "full", "block" },
                left_pad = 1,
                right_pad = 2,
                -- min_width = 20,
            },
            code = {
                -- Turn on / off code block & inline code rendering
                enabled = true,
                -- Turn on / off any sign column related rendering
                sign = false,
                -- Determines how code blocks & inline code are rendered:
                --  none: disables all rendering
                --  normal: adds highlight group to code blocks & inline code, adds padding to code blocks
                --  language: adds language icon to sign column if enabled and icon + name above code blocks
                --  full: normal + language
                style = "full",
                -- Amount of padding to add to the left of code blocks
                left_pad = 2,
                right_pad = 4,
                width = "block",
                -- Determins how the top / bottom of code block are rendered:
                --  thick: use the same highlight as the code body
                --  thin: when lines are empty overlay the above & below icons
                border = "thin",
                -- Used above code blocks for thin border
                above = "", -- alts: ┄
                -- above = "▄",
                -- Used below code blocks for thin border
                below = "▀", -- alts: ─
                -- below = "▀",
                -- Highlight for code blocks & inline code
                highlight = "RenderMarkdownCode",
            },
            dash = {
                -- Turn on / off thematic break rendering
                enabled = true,
                -- Replaces '---'|'***'|'___'|'* * *' of 'thematic_break'
                -- The icon gets repeated across the window's width
                -- icon = "─",
                icon = "┈",
                -- icon = "░",
                -- Highlight for the whole line generated from the icon
                highlight = "RenderMarkdownDash",
            },
            bullet = {
                -- Turn on / off list bullet rendering
                enabled = true,
                -- Replaces '-'|'+'|'*' of 'list_item'
                -- How deeply nested the list is determines the 'level'
                -- The 'level' is used to index into the array using a cycle
                -- If the item is a 'checkbox' a conceal is used to hide the bullet instead
                icons = { "•", "∘", "▪", "▫", "" }, -- alts: ◦
                -- Highlight for the bullet icon
                highlight = "RenderMarkdownBullet",
            },
            checkbox = {
                -- Turn on / off checkbox state rendering
                enabled = true,
                unchecked = {
                    -- Replaces '[ ]' of 'task_list_marker_unchecked'
                    icon = " ", -- alts: 󰄱
                    -- Highlight for the unchecked icon
                    highlight = "RenderMarkdownUnchecked",
                },
                checked = {
                    -- Replaces '[x]' of 'task_list_marker_checked'
                    icon = " ", -- alts: 󰱒   
                    -- Highligh for the checked icon
                    highlight = "RenderMarkdownChecked",
                },
                -- Define custom checkbox states, more involved as they are not part of the markdown grammar
                -- As a result this requires neovim >= 0.10.0 since it relies on 'inline' extmarks
                -- Can specify as many additional states as you like following the 'todo' pattern below
                --   The key in this case 'todo' is for healthcheck and to allow users to change its values
                --   'raw': Matched against the raw text of a 'shortcut_link'
                --   'rendered': Replaces the 'raw' value when rendering
                --   'highlight': Highlight for the 'rendered' icon
                -- custom = {
                --   todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo" },
                -- },
                custom = {
                    -- todo = { raw = "[-]", rendered = " 󰥔 ", highlight = "RenderMarkdownTodo" },
                    todo = { raw = "[-]", rendered = "󱗽 ", highlight = "RenderMarkdownListTodo" },
                    event = { raw = "[|]", rendered = "󰀠 ", highlight = "RenderMarkdownListEvent" },
                    wip = { raw = "[.]", rendered = "󰡖 ", highlight = "RenderMarkdownListWip" },
                    -- trash = { raw = "[/]", rendered = " ", highlight = "RenderMarkdownListSkipped" },
                    skip = { raw = "[/]", rendered = " ", highlight = "RenderMarkdownListTrash" },

                    fire = { raw = "[f]", rendered = "󰈸 ", highlight = "RenderMarkdownListFire" },
                    star = { raw = "[s]", rendered = " ", highlight = "RenderMarkdownListStar" },
                    idea = { raw = "[*]", rendered = "󰌵 ", highlight = "RenderMarkdownListIdea" },
                    yes = { raw = "[y]", rendered = "󰔓 ", highlight = "RenderMarkdownListYes" },
                    no = { raw = "[n]", rendered = "󰔑 ", highlight = "RenderMarkdownListNo" },
                    question = { raw = "[?]", rendered = " ", highlight = "RenderMarkdownListQuestion" },
                    info = { raw = "[i]", rendered = " ", highlight = "RenderMarkdownListInfo" },
                    important = { raw = "[!]", rendered = "󱅶 ", highlight = "RenderMarkdownListImportant" },
                },
            },
            quote = {
                -- Turn on / off block quote & callout rendering
                enabled = true,
                -- Replaces '>' of 'block_quote'
                icon = "▐",
                -- Highlight for the quote icon
                highlight = "RenderMarkdownQuote",
            },
            pipe_table = {
                -- Turn on / off pipe table rendering
                enabled = true,
                -- Determines how the table as a whole is rendered:
                --  none: disables all rendering
                --  normal: applies the 'cell' style rendering to each row of the table
                --  full: normal + a top & bottom line that fill out the table when lengths match
                style = "full",
                -- Determines how individual cells of a table are rendered:
                --  overlay: writes completely over the table, removing conceal behavior and highlights
                --  raw: replaces only the '|' characters in each row, leaving the cells unmodified
                --  padded: raw + cells are padded with inline extmarks to make up for any concealed text
                cell = "padded",
                -- Characters used to replace table border
                -- Correspond to top(3), delimiter(3), bottom(3), vertical, & horizontal
                -- stylua: ignore
                border = {
                    '┌', '┬', '┐',
                    '├', '┼', '┤',
                    '└', '┴', '┘',
                    '│', '─',
                },
                -- Highlight for table heading, delimiter, and the line above
                head = "RenderMarkdownTableHead",
                -- Highlight for everything else, main table rows and the line below
                row = "RenderMarkdownTableRow",
                -- Highlight for inline padding used to add back concealed space
                filler = "RenderMarkdownTableFill",
            },
            -- Callouts are a special instance of a 'block_quote' that start with a 'shortcut_link'
            -- Can specify as many additional values as you like following the pattern from any below, such as 'note'
            --   The key in this case 'note' is for healthcheck and to allow users to change its values
            --   'raw': Matched against the raw text of a 'shortcut_link', case insensitive
            --   'rendered': Replaces the 'raw' value when rendering
            --   'highlight': Highlight for the 'rendered' text and quote markers
            callout = {
                note = { raw = "[!NOTE]", rendered = "󰋽 Note", highlight = "RenderMarkdownInfo" },
                tip = { raw = "[!TIP]", rendered = "󰌶 Tip", highlight = "RenderMarkdownSuccess" },
                important = { raw = "[!IMPORTANT]", rendered = "󰅾 Important", highlight = "RenderMarkdownHint" },
                warning = { raw = "[!WARNING]", rendered = "󰀪 Warning", highlight = "RenderMarkdownWarn" },
                caution = { raw = "[!CAUTION]", rendered = "󰳦 Caution", highlight = "RenderMarkdownError" },
                -- Obsidian: https://help.a.md/Editing+and+formatting/Callouts
                abstract = { raw = "[!ABSTRACT]", rendered = "󰨸 Abstract", highlight = "RenderMarkdownInfo" },
                todo = { raw = "[!TODO]", rendered = "󰗡 Todo", highlight = "RenderMarkdownInfo" },
                success = { raw = "[!SUCCESS]", rendered = "󰄬 Success", highlight = "RenderMarkdownSuccess" },
                question = { raw = "[!QUESTION]", rendered = "󰘥 Question", highlight = "RenderMarkdownWarn" },
                failure = { raw = "[!FAILURE]", rendered = "󰅖 Failure", highlight = "RenderMarkdownError" },
                danger = { raw = "[!DANGER]", rendered = "󱐌 Danger", highlight = "RenderMarkdownError" },
                bug = { raw = "[!BUG]", rendered = "󰨰 Bug", highlight = "RenderMarkdownError" },
                example = { raw = "[!EXAMPLE]", rendered = "󰉹 Example", highlight = "RenderMarkdownHint" },
                quote = { raw = "[!QUOTE]", rendered = "󱆨 Quote", highlight = "RenderMarkdownQuote" },
            },
            -- link = {
            --   -- Turn on / off inline link icon rendering
            --   enabled = true,
            --   -- Inlined with 'image' elements
            --   image = "󰥶 ",
            --   -- Inlined with 'inline_link' elements
            --   hyperlink = "󰌹 ",
            --   -- Applies to the inlined icon
            --   highlight = "RenderMarkdownLink",
            -- },
            --
            link = {
                enabled = true,
                image = "󰥶 ",
                email = "󰀓 ",
                hyperlink = "󰌹 ",
                highlight = "RenderMarkdownLink",
                custom = {
                    web = { pattern = "^http[s]?://", icon = "󰖟 ", highlight = "RenderMarkdownLink" },
                },
            },
            sign = {
                -- Turn on / off sign rendering
                enabled = true,
                -- More granular mechanism, disable signs within specific buftypes
                exclude = {
                    buftypes = { "nofile" },
                },
                -- Applies to background of sign text
                highlight = "RenderMarkdownSign",
            },
        }
    },
    {
        "epwalsh/obsidian.nvim",
        event = {
            "BufReadPre " .. vim.fn.expand("~") .. "/zet/*.md",
            "BufNewFile " .. vim.fn.expand("~") .. "/zet/*.md",
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        opts = {
            workspaces = {
                {
                    name = "Universal",
                    path = "~/zet",
                },
            },
            templates = {
                folder = "templates",
                date_format = "%Y-%m-%d-%a",
                time_format = "%H:%M",
            },
            ui = { enable = false },
            node_id_func = function(title)
                local suffix = ""
                if title ~= nil then
                    suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
                else
                    for _ = 1, 4 do
                        suffix = suffix .. string.char(math.random(65, 90))
                    end
                end
                return tostring(os.time()) .. "-" .. suffix
            end
        },
        config = function(_, opts)
            require("obsidian").setup(opts)
            vim.keymap.set("n", "<localleader>on", "<cmd>ObsidianNew<CR>")
        end
    }
}
