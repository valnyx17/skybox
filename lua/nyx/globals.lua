-- See https://www.compart.com/en/unicode to search Unicode

local borders = {
    none = { '', '', '', '', '', '', '', '' },
    invs = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
    thin = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
    edge = { '🭽', '▔', '🭾', '▕', '🭿', '▁', '🭼', '▏' }, -- Works in Kitty, Wezterm
    empty = { " ", " ", " ", " ", " ", " ", " ", " " },
}

_G.v = {
    lsp = require("nyx.lsp"),
    test = {
        icons = {
            passed = "", --alts: 
            failed = "", --alts: 
            running = "",
            skipped = "○",
            unknown = "", -- alts: 
        },
    },
    ui = {
        cur_border = borders.invs,
        borders = borders,
        icons = {
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
            branch = '',
            bullet = '•',
            o_bullet = '○',
            -- d_chev = '∨',
            d_chev = '▾',
            ellipses = '…',
            file = '╼ ',
            hamburger = '≡',
            diamond = '◇',
            tab = "→ ",
            -- r_chev = '>',
            -- r_chev = '',
            r_chev = '▸',
            location = '⌘',
            square = '□ ',
            ballot_x = '🗴',
            up_tri = '▲',
            info_i = '¡',
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
        }
    },
    nonprog_modes = {
        ["json"] = true,
        ["markdown"] = true,
        ["org"] = true,
        ["orgagenda"] = true,
        ["text"] = true,
    }
}

-- ┌────────┐
-- │settings│
-- └────────┘

-- Stop search highlighting after moving
-- https://www.reddit.com/r/neovim/comments/zc720y/tip_to_manage_hlsearch/
vim.on_key(function(char)
    if vim.fn.mode() == "n" then
        local new_hlsearch = vim.tbl_contains({
            "<CR>",
            "n",
            "N",
            "*",
            "#",
            "?",
            "/",
        }, vim.fn.keytrans(char))
        if vim.opt.hlsearch:get() ~= new_hlsearch then vim.opt.hlsearch = new_hlsearch end
    end
end, vim.api.nvim_create_namespace "auto_hlsearch")


-- ┌─────────┐
-- │functions│
-- └─────────┘
--------------------------------------------------
-- files and directories
--------------------------------------------------
-- provides a place to cache the root
-- directory for current editing session
local branch_cache = {}
local remote_cache = {}

--- get the path to the root of the current file. The
-- root can be anything we define, such as ".git",
-- "Makefile", etc.
-- see https://www.reddit.com/r/neovim/comments/zy5s0l/you_dont_need_vimrooter_usually_or_how_to_set_up/
-- @tparam  path: file to get root of
-- @treturn path to the root of the filepath parameter
v.get_path_root = function(path)
    if path == "" then return end

    local root = vim.b.path_root
    if root ~= nil then return root end

    local root_items = {
        ".git"
    }

    root = vim.fs.root(0, root_items)
    if root == nil then return nil end
    vim.b.path_root = root

    return root
end

-- get the name of the remote repository
v.get_git_remote_name = function(root)
    if root == nil then return end

    local remote = remote_cache[root]
    if remote ~= nil then return remote end

    -- see https://stackoverflow.com/a/42543006
    -- "basename" "-s" ".git" "`git config --get remote.origin.url`"
    local cmd = table.concat({ "git", "config", "--get remote.origin.url" }, " ")
    remote = vim.fn.system(cmd)

    if vim.v.shell_error ~= 0 then return nil end

    remote = vim.fs.basename(remote)
    if remote == nil then return end

    remote = vim.fn.fnamemodify(remote, ":r")
    remote_cache[root] = remote

    return remote
end

v.set_git_branch = function(root)
    local cmd = table.concat({ "git", "-C", root, "branch --show-current" }, " ")
    local branch = vim.fn.system(cmd)
    if branch == nil then return nil end

    branch = branch:gsub("\n", "")
    branch_cache[root] = branch

    return branch
end

v.get_git_branch = function(root)
    if root == nil then return end

    local branch = branch_cache[root]
    if branch ~= nil then return branch end

    return v.set_git_branch(root)
end

v.is_nonprog_ft = function()
    return v.nonprog_modes[vim.bo.filetype] ~= nil
end


--------------------------------------------------
-- LSP
--------------------------------------------------
v.diagnostics_available = function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    local diagnostics = vim.lsp.protocol.Methods.textDocument_publishDiagnostics

    for _, cfg in pairs(clients) do
        if cfg.supports_method(diagnostics) then return true end
    end

    return false
end


--------------------------------------------------
-- Highlighting
--------------------------------------------------
v.hl_str = function(hl, str)
    return "%#" .. hl .. "#" .. str .. "%*"
end

-- Stolen from toggleterm.nvim
--
---Convert a hex color to an rgb color
---@param hex string
---@return number
---@return number
---@return number
local function hex_to_rgb(hex)
    if hex == nil then
        hex = "#000000"
    end
    return tonumber(hex:sub(2, 3), 16),
        tonumber(hex:sub(4, 5), 16),
        tonumber(hex:sub(6), 16)
end


-- Stolen from toggleterm.nvim
--
-- SOURCE: https://stackoverflow.com/questions/5560248/programmatically-lighten-or-darken-a-hex-color-or-rgb-and-blend-colors
-- @see: https://stackoverflow.com/questions/37796287/convert-decimal-to-hex-in-lua-4
--- Shade Color generate
--- @param hex string hex color
--- @param percent number
--- @return string
v.tint = function(hex, percent)
    local r, g, b = hex_to_rgb(hex)

    -- If any of the colors are missing return "NONE" i.e. no highlight
    if not r or not g or not b then return "NONE" end

    r = math.floor(tonumber(r * (100 + percent) / 100) or 0)
    g = math.floor(tonumber(g * (100 + percent) / 100) or 0)
    b = math.floor(tonumber(b * (100 + percent) / 100) or 0)
    r, g, b = r < 255 and r or 255, g < 255 and g or 255, b < 255 and b or 255

    return "#" .. string.format("%02x%02x%02x", r, g, b)
end


---Get a hl group's rgb
---Note: Always gets linked colors
---@param opts table
---@param ns_id integer?
---@return table
v.get_hl_hex = function(opts, ns_id)
    opts, ns_id = opts or {}, ns_id or 0
    assert(opts.name or opts.id, "Error: must have hl group name or ID!")
    opts.link = true

    local hl = vim.api.nvim_get_hl(ns_id, opts)

    return {
        fg = hl.fg and ('#%06x'):format(hl.fg),
        bg = hl.bg and ('#%06x'):format(hl.bg)
    }
end

-- insert grouping separators in numbers
-- viml regex: https://stackoverflow.com/a/42911668
-- lua pattern: stolen from Akinsho
v.group_number = function(num, sep)
    if num < 999 then
        return tostring(num)
    else
        num = tostring(num)
        return num:reverse():gsub('(%d%d%d)', '%1' .. sep):reverse():gsub('^,', '')
    end
end

--- check if a certain feature/version/commit exists in nvim
---@param feature string
---@return boolean
v.has = function(feature)
    return vim.fn.has(feature) > 0
end
