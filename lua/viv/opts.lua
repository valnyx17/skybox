vim.env.XDG_CONFIG_HOME = vim.env.XDG_CONFIG_HOME or (vim.env.HOME .. "/.config")

-- undercurl
vim.api.nvim_set_var('t_Cs', [[\e[4:3m]])
vim.api.nvim_set_var('t_Ce', [[\e[4:0m]])

local g = vim.g
local o = vim.opt

-- leader keys
g.mapleader = " "
g.maplocalleader = ","

g.lazy_events_config = {
  simple = {
    LazyFile = { "BufReadPost", "BufNewFile", "BufWritePre" },
    TermUsed = { "TermOpen", "TermEnter", "TermLeave", "TermClose" },
  },
  projects = {
    docker = { "Dockerfile", "compose.y*ml", "docker-compose.y*ml" },
    cpplib = {
      any = { "Makefile", "CMakeLists.txt", "Justfile", "BUILD", "BUILD.bazel" },
      all = { "**/*.cpp", "**/*.h*" }, -- all expresions must match something
    },
  },
}

o.cmdheight = 0

-- better word movement
o.iskeyword:remove({ ".", "_", "$" })

o.showtabline = 1 -- only when two or more tabs
o.laststatus = 3

-- line numbers
o.signcolumn = "auto:2"
o.foldcolumn = "auto:1"
o.number = true
o.relativenumber = true

-- disable mouse
o.mouse = ""
o.mousescroll = "ver:8,hor:6"
o.mousemoveevent = true

-- tabs
o.tabstop = 4
o.vartabstop = "4" -- all tabs represented as four spaces
o.shiftwidth = 0 -- use tabstop
o.softtabstop = -1 -- use shiftwidth
o.expandtab = true -- <Tab> inserts spaces, <C-v><Tab> inserts <Tab>

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
  shift = 2
}
o.showbreak = "↪ "

o.updatetime = 200 -- time until swap write, also used for CursorHold
o.completeopt = { "menu", "menuone", "noinsert", "noselect" } -- display always, force user to select and insert

-- backup
o.backup = true
o.writebackup = true
o.backupdir = { vim.fn.stdpath("state") .. "/backup" }

-- misc.
o.exrc = true -- autorun: .nvim.lua, .nvimrc, and .exrc files in CWD
o.concealcursor = ""
o.conceallevel = 2 -- :h cole
o.confirm = true -- instead of failing, confirm when a ! could be appended to force
o.showmode = false
o.history = 1000 -- cmd history size

-- make sure there's 8 lines of context
o.scrolloff = 8
o.sidescrolloff = 8

-- save undos
o.undofile = true

-- scrolling works with screen lines
o.smoothscroll = true

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
o.wildoptions = o.wildoptions + "fuzzy"
o.whichwrap = o.whichwrap + "<,>,h,l,[,],b,s"
o.diffopt = {
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
o.cursorline = true
o.foldlevel = 99
o.foldlevelstart = 99
o.foldmethod = "expr"
o.foldexpr = "nvim_treesitter#foldexpr()"
o.foldtext = ""

-- icons
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
  -- foldclose = v.ui.icons.r_chev,
  -- foldopen = v.ui.icons.d_chev,
  foldclose = " ",
  foldopen = " ",
  diff = "╱", -- alts: = ⣿ ░ ─
  msgsep = "━", -- alts:   ‾ ─
  stl = " ", -- alts: ─ ⣿ ░ ▐ ▒▓
  stlnc = " ", -- alts: ─
}
o.list = true
o.listchars = {
  extends = "›", -- alts: … » ▸
  precedes = "‹", -- alts: … « ◂
  trail = "·", -- alts: • BULLET (U+2022, UTF-8: E2 80 A2)
  tab = "  ", -- alts: »  »│ │ →
  nbsp = "◇", -- alts: ⦸ ␣
  eol = nil, -- alts: 󰌑
}

o.timeoutlen = 250
o.termguicolors = true

o.pumheight = 25     -- pop up menu height
o.smartindent = true -- make indenting smarter again
o.showcmd = false    -- Don't show the command in the last line
o.ruler = false      -- Don't show the ruler
o.title = false      -- don't set the title of window to the value of the titlestring
o.belloff = "all"    -- I NEVER WANT TO HEAR THE BELL.
o.visualbell = false
o.ttyfast = true     -- let vim know i am using a fast term
o.autoread = true
o.wildmode = {       -- shell-like autocomplete to unambiguous portions
  "longest",
  "list",
  "full",
}
o.formatoptions = o.formatoptions
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
o.shortmess = o.shortmess
    + "A" -- ignore annoying swapfile messages
    + "I" -- no spash screen
    + "O" -- file-read message overrites previous
    + "T" -- truncate non-file messages in middle
    + "W" -- don't echo '[w]/[written]' when writing
    + "a" -- use abbreviations in message '[ro]' instead of '[readonly]'
    + "o" -- overwrite file-written mesage
    + "t" -- truncate file messages at start
    + "c" -- dont show matching messages

o.joinspaces = true
o.clipboard:append({ "unnamedplus" })

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
  o.grepprg = "rg --vimgrep --smart-case --follow"
  o.grepformat = "%f:%l:%c:%m"
end
