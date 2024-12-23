return {
    setup = function()
        vim.env.XDG_CONFIG_HOME = vim.env.XDG_CONFIG_HOME or (vim.env.HOME .. "/.config")

        local conf = {
            g = {
                mapleader = " ",
                maplocalleader = ",",
                neovide_hide_mouse_when_typing = true,
                neovide_remember_window_size = true,
                neovide_cursor_vfx_mode = "wireframe",
                neovide_cursor_animation_length = 0.03,
                neovide_cursor_trail_size = 0.9,
                neovide_refresh_rate = 144,
                neovide_padding_top = 20,
                neovide_padding_bottom = 20,
                neovide_padding_right = 20,
                neovide_padding_left = 20,
                neovide_transparency = 0.95,
                guifont = "CommitMono:h12.5:#e-subpixelantialias",
            },
            opt = {
                cmdheight = 0,
                guicursor = {
                    "n-v:block-Cursor/lCursor",
                    "i-c-ci-ve:ver35-DiagnosticOk",
                    "r-cr-o:hor20-DiagnosticError",
                },
                iskeyword = vim.opt.iskeyword - { ".", "_", "$" },
                showtabline = 1,
                laststatus = 3,
                -- laststatus = 2,
                -- line numbers
                signcolumn = "auto:2",
                foldcolumn = "auto:1",
                relativenumber = true,
                number = true,
                -- enable mouse
                mouse = "a",
                mousescroll = "ver:8,hor:6",
                mousemoveevent = true,
                -- tabs
                tabstop = 4,
                vartabstop = "4", -- all tabs represented as four spaces
                shiftwidth = 0,   -- tabstop
                softtabstop = -1, -- use shiftwidth
                expandtab = true, -- <Tab> inserts spaces, ^V<Tab> inserts <Tab>
                -- searching
                ignorecase = true,
                smartcase = true,
                inccommand = "split",
                -- more intuitive splits
                splitright = true,
                splitbelow = true,
                -- linebreaks
                linebreak = true,
                breakindent = true,
                wrap = true,
                textwidth = 120,
                breakindentopt = {
                    shift = 2,
                },
                showbreak = "↪ ",
                -- popup menu
                -- pumblend = 20, -- transparency???
                updatetime = 200,                                            -- time until swap write, also used for CursorHold
                completeopt = { "menu", "menuone", "noinsert", "noselect" }, -- display always, force user to select and insert
                -- backup
                backup = true,
                writebackup = true,
                backupdir = { vim.fn.stdpath("state") .. "/backup" },
                -- misc.
                exrc = true,         -- automatically runs .nvim.lua, .nvimrc, and .exrc files in the current directory
                concealcursor = "",
                conceallevel = 2,    -- :h cole
                confirm = true,      -- instead of failing, confirm when a ! could be appended to force
                showmode = false,
                history = 1000,      -- cmd history size
                scrolloff = 8,
                sidescrolloff = 8,   -- Makes sure there are always eight lines of context
                undofile = true,
                smoothscroll = true, -- scrolling works with screen lines
                sessionoptions = {
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
                },
                diffopt = {
                    -- :h 'diffopt'
                    "vertical",
                    "iwhite",
                    "hiddenoff",
                    "foldcolumn:0",
                    "context:4",
                    "algorithm:histogram",
                    "indent-heuristic",
                    "linematch:60",
                },
                -- ui stuff
                cursorline = true,
                foldlevel = 99,
                foldlevelstart = 99,
                -- foldmethod = "indent",
                foldmethod = "expr",
                foldexpr = "nvim_treesitter#foldexpr()",
                foldtext = "",
                fillchars = {
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
                },
                list = true,
                listchars = {
                    extends = "›", -- alts: … » ▸
                    precedes = "‹", -- alts: … « ◂
                    trail = "·", -- alts: • BULLET (U+2022, UTF-8: E2 80 A2)
                    tab = "  ", -- alts: »  »│ │ →
                    nbsp = "◇", -- alts: ⦸ ␣
                    eol = nil, -- alts: 󰌑
                },
                timeoutlen = 250,
                termguicolors = true,

                -- pumheight = 10,     -- pop up menu height
                pumheight = 25,     -- pop up menu height
                smartindent = true, -- make indenting smarter again
                showcmd = false,    -- Don't show the command in the last line
                ruler = false,      -- Don't show the ruler
                title = false,      -- don't set the title of window to the value of the titlestring
                belloff = "all",    -- I NEVER WANT TO HEAR THE BELL.
                visualbell = false,
                ttyfast = true,     -- let vim know i am using a fast term
                autoread = true,
                wildmode = {        -- shell-like autocomplete to unambiguous portions
                    "longest",
                    "list",
                    "full",
                },
                formatoptions = vim.opt.formatoptions
                    - "a"  -- dont autoformat
                    - "t"  -- dont autoformat my code, have linters for that
                    + "c"  -- auto wrap comments using textwith
                    + "q"  -- formmating of comments w/ `gq`
                    -- + "l" -- long lines are not broken up
                    + "j"  -- remove comment leader when joining comments
                    + "r"  -- continue comment with enter
                    - "o"  -- but not w/ o and o, dont continue comments
                    + "n"  -- smart auto indenting inside numbered lists
                    - "2", -- this is not grade school anymore
                shortmess = vim.opt.shortmess
                    + "A"  -- ignore annoying swapfile messages
                    + "I"  -- no spash screen
                    + "O"  -- file-read message overrites previous
                    + "T"  -- truncate non-file messages in middle
                    + "W"  -- don't echo '[w]/[written]' when writing
                    + "a"  -- use abbreviations in message '[ro]' instead of '[readonly]'
                    + "o"  -- overwrite file-written mesage
                    + "t"  -- truncate file messages at start
                    + "c", -- dont show matching messages
                joinspaces = true,
                -- clipboard = { "unnamed", "unnamedplus" },
                clipboard = vim.opt.clipboard + "unnamedplus",
                -- clipboard = "unnamedplus",
            },
        }
        vim.opt.wildoptions:append("fuzzy") --  add fuzzy completion to cmdline-completion
        vim.opt.whichwrap:append("<,>,h,l,[,],b,s")
        vim.schedule(function()
            -- vim.o.spell = true
            vim.o.spelllang = "en"
        end)
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
        vim.cmd.aunmenu([[PopUp.How-to\ disable\ mouse]])
        vim.cmd.amenu([[PopUp.:Inspect <Cmd>Inspect<CR>]])
        vim.cmd.amenu([[PopUp.:Telescope <Cmd>Telescope<CR>]])
        vim.cmd.amenu([[PopUp.Code\ action <Cmd>lua vim.lsp.buf.code_action()<CR>]])
        vim.cmd.amenu([[PopUp.LSP\ Hover <Cmd>lua vim.lsp.buf.hover()<CR>]])
        if vim.fn.executable("rg") then
            conf.opt.grepprg = "rg --vimgrep --smart-case --follow"
            conf.opt.grepformat = "%f:%l:%c:%m"
        end
        for scope, ops in pairs(conf) do
            local opt_group = vim[scope]
            for k, v in pairs(ops) do
                opt_group[k] = v
            end
        end
    end,
}
