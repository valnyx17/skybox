local borders = {
    none = { "", "", "", "", "", "", "", "" },
    invs = { " ", " ", " ", " ", " ", " ", " ", " " },
    thin = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    edge = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" }, -- Works in Kitty, Wezterm
    empty = { " ", " ", " ", " ", " ", " ", " ", " " },
}

local M = {
    cur_border = borders.invs,
    borders = borders,
    icons = {
        kind = {
            Array = "",
            Boolean = "",
            Class = "󰠱",
            -- Class = "", -- Class
            Codeium = "",
            Color = "󰏘",
            -- Color = "", -- Color
            Constant = "󰏿",
            -- Constant = "", -- Constant
            Constructor = "",
            -- Constructor = "", -- Constructor
            Enum = "", -- alts: 
            -- Enum = "", -- Enum -- alts: 了
            EnumMember = "", -- alts: 
            -- EnumMember = "", -- EnumMember
            Event = "",
            Field = "󰜢",
            File = "󰈙",
            -- File = "", -- File
            Folder = "󰉋",
            -- Folder = "", -- Folder
            Function = "󰊕",
            Interface = "",
            Key = "",
            Keyword = "󰌋",
            -- Keyword = "", -- Keyword
            Method = "",
            Module = "",
            Namespace = "",
            Null = "󰟢", -- alts: 󰱥󰟢
            Number = "󰎠", -- alts: 
            Object = "",
            -- Operator = "\u{03a8}", -- Operator
            Operator = "󰆕",
            Package = "",
            Property = "󰜢",
            -- Property = "", -- Property
            Reference = "󰈇",
            Snippet = "", -- alts: 
            String = "", -- alts:  󱀍 󰀬 󱌯
            Struct = "󰙅",
            Text = "󰉿",
            TypeParameter = "",
            Unit = "󰑭",
            -- Unit = "", -- Unit
            Value = "󰎠",
            Variable = "󰀫",
            -- Variable = "", -- Variable, alts: 

            -- Text = "",
            -- Method = "",
            -- Function = "",
            -- Constructor = "",
            -- Field = "",
            -- Variable = "",
            -- Class = "",
            -- Interface = "",
            -- Module = "",
            -- Property = "",
            -- Unit = "",
            -- Value = "",
            -- Enum = "",
            -- Keyword = "",
            -- Snippet = "",
            -- Color = "",
            -- File = "",
            -- Reference = "",
            -- Folder = "",
            -- EnumMember = "",
            -- Constant = "",
            -- Struct = "",
            -- Event = "",
            -- Operator = "",
            -- TypeParameter = "",
        },
        vscode = {
            Text = "󰉿 ",
            Method = "󰆧 ",
            Function = "󰊕 ",
            Constructor = " ",
            Field = "󰜢 ",
            Variable = "󰀫 ",
            Class = "󰠱 ",
            Interface = " ",
            Module = " ",
            Property = "󰜢 ",
            Unit = "󰑭 ",
            Value = "󰎠 ",
            Enum = " ",
            Keyword = "󰌋 ",
            Snippet = " ",
            Color = "󰏘 ",
            File = "󰈙 ",
            Reference = "󰈇 ",
            Folder = "󰉋 ",
            EnumMember = " ",
            Constant = "󰏿 ",
            Struct = "󰙅 ",
            Event = " ",
            Operator = "󰆕 ",
            TypeParameter = " ",
        },
        branch = "",
        bullet = "•",
        o_bullet = "○",
        -- d_chev = '∨',
        d_chev = "▾",
        ellipses = "…",
        file = "╼ ",
        hamburger = "≡",
        diamond = "◇",
        tab = "→ ",
        -- r_chev = '>',
        -- r_chev = '',
        r_chev = "▸",
        location = "⌘",
        square = "□ ",
        ballot_x = "🗴",
        up_tri = "▲",
        info_i = "¡",
        hint = "󰌵",
        formatter = "", -- alts: 󰉼
        buffers = "",
        clock = "",
        ellipsis = "…",
        lblock = "▌",
        rblock = "▐",
        bug = "", -- alts: 
        question = "",
        lock = "󰌾", -- alts:   
        shaded_lock = "",
        circle = "",
        project = "",
        dashboard = "",
        history = "󰄉",
        comment = "󰅺",
        robot = "󰚩", -- alts: 󰭆
        lightbulb = "󰌵",
        file_tree = "󰙅",
        help = "󰋖", -- alts: 󰘥 󰮥 󰮦 󰋗 󰞋 󰋖
        search = "", -- alts: 󰍉
        code = "",
        telescope = "",
        terminal = "", -- alts: 
        gear = "",
        package = "",
        list = "",
        sign_in = "",
        check = "✓", -- alts: ✓
        fire = "",
        note = "󰎛",
        bookmark = "",
        pencil = "󰏫",
        arrow_right = "",
        caret_right = "",
        chevron_right = "",
        double_chevron_right = "»",
        table = "",
        calendar = "",
        flames = "󰈸", -- alts: 󱠇󰈸
        vsplit = "◫",
        v_border = "▐ ",
        virtual_text = "◆",
        mode_term = "",
        ln_sep = "ℓ", -- alts: ℓ 
        sep = "⋮",
        perc_sep = "",
        modified = "", -- alts: ∘✿✸✎ ○∘●●∘■ □ ▪ ▫● ◯ ◔ ◕ ◌ ◎ ◦ ◆ ◇ ▪▫◦∘∙⭘
        mode = "",
        vcs = "",
        readonly = "",
        prompt = "",
        markdown = {
            h1 = "◉", -- alts: 󰉫¹◉
            h2 = "◆", -- alts: 󰉬²◆
            h3 = "󱄅", -- alts: 󰉭³✿
            h4 = "⭘", -- alts: 󰉮⁴○⭘
            h5 = "◌", -- alts: 󰉯⁵◇◌
            h6 = "", -- alts: 󰉰⁶
            dash = "",
        },
    },
    git = {
        icons = {
            add = "▕", -- alts:  ▕,▕, ▎, ┃, │, ▌, ▎ 🮉
            change = "▕", -- alts:  ▕ ▎║▎
            mod = "",
            remove = "", -- alts: 
            delete = "🮉", -- alts: ┊▎▎
            topdelete = "🮉",
            changedelete = "🮉",
            untracked = "▕",
            ignore = "",
            rename = "",
            diff = "",
            repo = "",
            symbol = "", -- alts:  
            unstaged = "󰛄",
        },
    },
}

M.pad_str = function(in_str, width, align)
    local num_spaces = width - #in_str
    if num_spaces < 1 then
        num_spaces = 1
    end

    local spaces = string.rep(" ", num_spaces)

    if align == "left" then
        return table.concat({ in_str, spaces })
    end

    return table.concat({ spaces, in_str })
end

return M
