-- IF THESE OPTIONS DO NOT TAKE EFFECT, RUN:
-- lua package.loaded = {}
-- IN THE NEOVIM CMDLINE.

vim.env.XDG_CONFIG_HOME = vim.env.XDG_CONFIG_HOME or (vim.env.HOME .. "/.config")
local g = vim.g
local o = vim.opt

o.cmdheight = 1
o.showtabline = 1
o.laststatus = 3

-- line numbers
o.signcolumn = "auto:2"
o.foldcolumn = "auto:1"
o.relativenumber = true
o.number = true

-- enable mouse
o.mouse = "a"
o.mousescroll = "ver:8,hor:6"
o.mousemoveevent = true

-- tabs
o.tabstop = 4
o.vartabstop = "4" -- all tabs represented as four spaces
o.shiftwidth = 0   -- tabstop
o.softtabstop = -1 -- use shiftwidth
o.expandtab = true -- <Tab> inserts spaces, ^V<Tab> inserts <Tab>

-- searching
o.ignorecase = true
o.smartcase = true
o.inccommand = "split"

-- more intuitive splits
o.splitright = true
o.splitbelow = true

-- linebreaks
o.linebreak = true
o.breakindent = true
o.wrap = true
o.textwidth = 120
o.breakindentopt = {
    shift = 2,
}

-- popup menu
-- o.pumblend = 20 -- transparency???
-- o.updatetime = 500                                            -- time until swap write, also used for CursorHold
o.updatetime = 200                                            -- time until swap write, also used for CursorHold
o.completeopt = { "menu", "menuone", "noinsert", "noselect" } -- display always, force user to select and insert

-- backup
o.backup = true
o.writebackup = true
o.backupdir = { vim.fn.stdpath("state") .. "/backup" }

-- misc.
o.exrc = true         -- automatically runs .nvim.lua, .nvimrc, and .exrc files in the current directory
o.concealcursor = ""
o.conceallevel = 2    -- :h cole
o.confirm = true      -- instead of failing, confirm when a ! could be appended to force
o.showmode = false
o.history = 1000      -- cmd history size
o.scrolloff = 8
o.sidescrolloff = 8   -- Makes sure there are always eight lines of context
o.undofile = true
o.smoothscroll = true -- scrolling works with screen lines
o.sessionoptions = {
    -- :h 'sessionoptions'
    "buffers",
    "curdir",
    "folds",
    -- "help",
    "tabpages",
    "winsize",
    -- "globals",
    -- "terminal",
    -- "options",
}
o.wildoptions:append("fuzzy") --  add fuzzy completion to cmdline-completion
o.diffopt = {
    -- :h 'diffopt'
    "internal",
    "filler",
    "vertical",
    "linematch:60",
}

-- ui stuff
o.cursorline = true
o.whichwrap:append("<,>,h,l,[,],b,s")
o.foldlevelstart = 4
o.foldtext = ""
o.fillchars = {
    horiz = "━",
    horizup = "┻",
    horizdown = "┳",
    vert = "┃",
    vertleft = "┫",
    vertright = "┣",
    verthoriz = "╋",
    eob = " ",
    -- eob = "╼",
    fold = " ",
    -- foldopen = "",
    foldsep = " ",
    foldclose = tools.ui.icons.r_chev,
    foldopen = tools.ui.icons.d_chev,
    diff = "╱",
    msgsep = '━',
}
o.list = true
o.listchars = {
    -- extends = "»",
    -- precedes = "«",
    extends = "▸",
    precedes = "◂",
    -- trail = "·•",
    trail = "·",
    -- tab = "│ ",
    tab = "  ",
    -- tab = "→ ",
    -- nbsp = "⦸",
    nbsp = "◇",
    -- eol = "󰌑",
}
o.timeoutlen = 250
vim.api.nvim_create_autocmd("FileType", {
    callback = function()
        vim.opt_local.formatoptions:remove({ "o" })
    end,
})
o.termguicolors = true

vim.schedule(function()
    -- vim.o.spell = true
    vim.o.spelllang = "en"
end)

g.mapleader = " "
g.maplocalleader = ","

vim.diagnostic.config({
    virtual_text = {
        severity = vim.diagnostic.severity.ERROR,
        source = "if_many",
    },
    virtual_lines = { only_current_line = true },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "󰌵",
        },
    },
    float = {
        border = "single",
        format = function(d)
            -- return ("%s (%s) [%s]"):format(d.message, d.source, d.code or d.user_data.lsp.code)
            return ("%s (%s)"):format(d.message, d.source)
        end,
    },
})

vim.filetype.add({
    pattern = {
        ["${XDG_CONFIG_HOME}/waybar/config"] = "json",
        ["${XDG_CONFIG_HOME}/hypr/.-conf"] = "hyprlang",
        ["[jt]sconfig.*.json"] = "jsonc",
        --     ["%.env%.[%w_.-]+"] = "dotenv",
    },
    filename = {
        ["*.env.*"] = "dotenv",
    },
    extension = {
        rasi = "rasi",
        mdx = "markdown.mdx",
        sxcu = "json",
    },
})

-- gui stuff
-- o.guifont = "JuliaMono:h14:#e-subpixelantialias"
-- if g.neovide then
--     g.neovide_transparency = 0.95
--     g.neovide_refresh_rate = 144
--     g.neovide_cursor_vfx_mode = "ripple"
--     g.neovide_cursor_animation_length = 0.03
--     g.neovide_cursor_trail_size = 0.9
--     g.neovide_remember_window_size = true
-- end

vim.cmd.aunmenu([[PopUp.How-to\ disable\ mouse]])
vim.cmd.amenu([[PopUp.:Inspect <Cmd>Inspect<CR>]])
vim.cmd.amenu([[PopUp.:Telescope <Cmd>Telescope<CR>]])
vim.cmd.amenu([[PopUp.Code\ action <Cmd>lua vim.lsp.buf.code_action()<CR>]])
vim.cmd.amenu([[PopUp.LSP\ Hover <Cmd>lua vim.lsp.buf.hover()<CR>]])
o.pumheight = 10     -- pop up menu height
o.smartindent = true -- make indenting smarter again
o.showcmd = false    -- Don't show the command in the last line
o.ruler = false      -- Don't show the ruler
o.title = false      -- don't set the title of window to the value of the titlestring

o.belloff = "all"    -- I NEVER WANT TO HEAR THE BELL.
o.visualbell = false
if vim.fn.executable("rg") then
    o.grepprg = "rg --vimgrep --smart-case --follow"
    o.grepformat = "%f:%l:%c:%m"
end
o.ttyfast = true -- let vim know i am using a fast term
o.autoread = true

o.formatoptions = o.formatoptions -- :help fo-table
    - "a"                         -- dont autoformat
    - "t"                         -- dont autoformat my code, have linters for that
    + "c"                         -- auto wrap comments using textwith
    + "q"                         -- formmating of comments w/ `gq`
    + "l"                         -- long lines are not broken up
    + "j"                         -- remove comment leader when joning comments
    + "r"                         -- continue comment with enter
    - "o"                         -- but not w/ o and o, dont continue comments
    + "n"                         -- smart auto indenting inside numbered lists
    - "2"                         -- this is not grade school anymore

o.shortmess = o.shortmess
    + "A"      -- ignore annoying swapfile messages
    + "I"      -- no spash screen
    + "O"      -- file-read message overrites previous
    + "T"      -- truncate non-file messages in middle
    + "W"      -- dont echo '[w]/[written]' when writing
    + "a"      -- use abbreviations in message '[ro]' instead of '[readonly]'
    + "o"      -- overwrite file-written mesage
    + "t"      -- truncate file messages at start
    + "c"      -- dont show matching messages

o.wildmode = { -- shell-like autocomplete to unambiguous portions
    "longest",
    "list",
    "full",
}

o.joinspaces = true

o.clipboard = { "unnamed", "unnamedplus" }
