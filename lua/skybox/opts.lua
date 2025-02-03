vim.env.XDG_CONFIG_HOME = vim.env.XDG_CONFIG_HOME or (vim.env.HOME .. "/.config")
local set = vim.opt
local g = vim.g

-- Undercurl
vim.cmd [[let &t_Cs = "\e[4:3m"]]
vim.cmd [[let &t_Ce = "\e[4:0m"]]

g.mapleader = " "
g.maplocalleader = ","
g.neovide_hide_mouse_when_typing = true
g.neovide_remember_window_size = true
g.neovide_cursor_vfx_mode = "wireframe"
g.neovide_cursor_animation_length = 0.03
g.neovide_cursor_trail_size = 0.9
g.neovide_refresh_rate = 144
g.neovide_padding_top = 20
g.neovide_padding_bottom = 20
g.neovide_padding_right = 20
g.neovide_padding_left = 20
g.neovide_transparency = 0.95
g.guifont = "Sky Term:h12.5:#e-subpixelantialias"

set.hlsearch = false
set.cmdheight = 0
set.guicursor = {
  "n-v:block-Cursor/lCursor",
  "i-c-ci-ve:ver35-DiagnosticOk",
  "r-cr-o:hor20-DiagnosticError",
}
set.iskeyword:remove({ ".", "_", "$" })
set.showtabline = 1
set.laststatus = 3
-- laststatus = 2
-- line numbers
set.signcolumn = "auto:2"
set.foldcolumn = "auto:1"
set.relativenumber = true
set.number = true
-- enable mouse
set.mouse = "a"
set.mousescroll = "ver:8,hor:6"
set.mousemoveevent = true
-- tabs
set.tabstop = 4
set.vartabstop = "4" -- all tabs represented as four spaces
set.shiftwidth = 0   -- tabstop
set.softtabstop = -1 -- use shiftwidth
set.expandtab = true -- <Tab> inserts spaces, ^V<Tab> inserts <Tab>
-- searching
set.ignorecase = true
set.smartcase = true
set.inccommand = "split"
-- more intuitive splits
set.splitright = true
set.splitbelow = true
-- linebreaks
set.linebreak = true
set.breakindent = true
set.wrap = false -- see augroup 'rc/textwidth'
set.textwidth = 120
set.breakindentopt = {
  shift = 2
}
set.showbreak = "↪ "
-- popup menu
-- pumblend = 20, -- transparency???
set.updatetime = 200                                            -- time until swap write, also used for CursorHold
set.completeopt = { "menu", "menuone", "noinsert", "noselect" } -- display always, force user to select and insert
-- backup
set.backup = true
set.writebackup = true
set.backupdir = { vim.fn.stdpath("state") .. "/backup" }
-- misc.
set.exrc = true         -- automatically runs .nvim.lua, .nvimrc, and .exrc files in the current directory
set.concealcursor = ""
set.conceallevel = 2    -- :h cole
set.confirm = true      -- instead of failing, confirm when a ! could be appended to force
set.showmode = false
set.history = 1000      -- cmd history size
set.scrolloff = 8
set.sidescrolloff = 8   -- Makes sure there are always eight lines of context
set.undofile = true
set.smoothscroll = true -- scrolling works with screen lines
set.sessionoptions = {
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
set.wildoptions = set.wildoptions + "fuzzy"
set.whichwrap = set.whichwrap + "<,>,h,l,[,],b,s"
set.diffopt = {
  -- :h 'diffopt'
  "vertical",
  "iwhite",
  "hiddenoff",
  "foldcolumn:0",
  "context:4",
  "algorithm:histogram",
  "indent-heuristic",
  "linematch:60",
}
-- ui stuff
set.cursorline = true
set.foldlevel = 99
set.foldlevelstart = 99
-- foldmethod = "indent"
set.foldmethod = "expr"
set.foldexpr = "nvim_treesitter#foldexpr()"
set.foldtext = ""
set.fillchars = {
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
  -- foldclose = v.ui.icons.r_chev,
  -- foldopen = v.ui.icons.d_chev,
  foldclose = " ",
  foldopen = " ",
  diff = "╱", -- alts: = ⣿ ░ ─
  msgsep = "━", -- alts:   ‾ ─
  stl = " ", -- alts: ─ ⣿ ░ ▐ ▒▓
  stlnc = " ", -- alts: ─
}
set.list = true
set.listchars = {
  extends = "›", -- alts: … » ▸
  precedes = "‹", -- alts: … « ◂
  trail = "·", -- alts: • BULLET (U+2022, UTF-8: E2 80 A2)
  tab = "  ", -- alts: »  »│ │ →
  nbsp = "◇", -- alts: ⦸ ␣
  eol = nil, -- alts: 󰌑
}
set.timeoutlen = 250
set.termguicolors = true

-- pumheight = 10,     -- pop up menu height
set.pumheight = 25     -- pop up menu height
set.smartindent = true -- make indenting smarter again
set.showcmd = false    -- Don't show the command in the last line
set.ruler = false      -- Don't show the ruler
set.title = false      -- don't set the title of window to the value of the titlestring
set.belloff = "all"    -- I NEVER WANT TO HEAR THE BELL.
set.visualbell = false
set.ttyfast = true     -- let vim know i am using a fast term
set.autoread = true
set.wildmode = {       -- shell-like autocomplete to unambiguous portions
  "longest",
  "list",
  "full",
}
set.formatoptions = set.formatoptions
    - "a" -- dont autoformat
    - "t" -- dont autoformat my code, have linters for that
    + "c" -- auto wrap comments using textwith
    + "q" -- formmating of comments w/ `gq`
    -- + "l" -- long lines are not broken up
    + "j" -- remove comment leader when joining comments
    + "r" -- continue comment with enter
    - "o" -- but not w/ o and o, dont continue comments
    + "n" -- smart auto indenting inside numbered lists
    - "2" -- this is not grade school anymore
set.shortmess = set.shortmess
    + "A" -- ignore annoying swapfile messages
    + "I" -- no spash screen
    + "O" -- file-read message overrites previous
    + "T" -- truncate non-file messages in middle
    + "W" -- don't echo '[w]/[written]' when writing
    + "a" -- use abbreviations in message '[ro]' instead of '[readonly]'
    + "o" -- overwrite file-written mesage
    + "t" -- truncate file messages at start
    + "c" -- dont show matching messages

set.joinspaces = true
set.clipboard = vim.opt.clipboard + "unnamedplus"

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
if vim.fn.executable("rg") then
  set.grepprg = "rg --vimgrep --smart-case --follow"
  set.grepformat = "%f:%l:%c:%m"
end
