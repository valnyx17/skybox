vim.loader.enable()

-- clone mini.nvim manually in a way that it gets managed by mini.deps
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.uv.fs_stat(mini_path) then
    vim.cmd('echo "Installing `mini.nvim`" | redraw')
    local clone_cmd = {
        'git', 'clone', '--filter=blob:none',
        'https://github.com/echasnovski/mini.nvim', mini_path
    }
    vim.fn.system(clone_cmd)
    vim.cmd('packadd mini.nvim | helptags ALL')
    vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require('mini.deps').setup({ path = { package = path_package } })
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

local function colorscheme()
    add({
        source = "rmehri01/onenord.nvim"
    })
    local colors = {
        fg           = "#C8D0E0",
        fg_light     = "#E5E9F0",
        bg           = "#2E3440",
        gray         = "#646A76",
        light_gray   = "#6C7A96",
        cyan         = "#88C0D0",
        blue         = "#81A1C1",
        dark_blue    = "#5E81AC",
        green        = "#A3BE8C",
        light_green  = "#8FBCBB",
        dark_red     = "#BF616A",
        red          = "#D57780",
        light_red    = "#DE878F",
        pink         = "#E85B7A",
        dark_pink    = "#E44675",
        orange       = "#D08F70",
        yellow       = "#EBCB8B",
        purple       = "#B988B0",
        light_purple = "#B48EAD",
        none         = "NONE",
    }
    require("onenord").setup({
        custom_colors = colors,
        styles = {
            comments = "italic",
            variables = "bold",
            functions = "bold,italic"
        },
        custom_highlights = {
            IncSearch = {
                fg = colors.pink,
            },
            CurSearch = {
                fg = colors.bg,
                bg = colors.pink
            }
        }
    })
    vim.cmd.colorscheme("onenord") -- Load the colorscheme here.
end

local function mini()
    add({
        source = "echasnovski/mini.nvim"
    })

    prequire("plugins.mini")
end

local function snacks()
    add({
        source = "folke/snacks.nvim",
    })
    prequire("plugins.snacks")
end

local function lua_console()
    add({
        source = "YaroSpace/lua-console.nvim",
    })
    prequire("lua-console").setup()
end

local function nvim_tmux_nav()
    add({
        source = "alexghergh/nvim-tmux-navigation"
    })
    prequire("nvim-tmux-navigation").setup({
        disable_when_zoomed = true
    })
end

local function lsp()
    prequire("plugins.lsp")
end

local function treesitter()
    add({
        source = "nvim-treesitter/nvim-treesitter",
        checkout = "master",
        monitor = "main",
        hooks = {
            post_checkout = function()
                vim.cmd("TSUpdate")
            end,
        },
        depends = {
            "JoosepAlviste/nvim-ts-context-commentstring",
            "windwp/nvim-ts-autotag",
            "nvim-treesitter/nvim-treesitter-context",
        }
    })
    add({
        source = "nvim-treesitter/nvim-treesitter-textobjects"
    })

    prequire("plugins.treesitter")
end

local function blink()
    add({
        source = "saghen/blink.cmp",
        depends = {
            "rafamadriz/friendly-snippets",
            "folke/lazydev.nvim",
            "Bilal2453/luvit-meta"
        },
        checkout = "v0.5.1"
    })

    prequire("plugins.blink")
end

local function statuscol()
    add({
        source = "luukvbaal/statuscol.nvim"
    })
    prequire("plugins.statuscol")
end

local function session_manager()
    add({
        source = "rmagatti/auto-session"
    })
    prequire("auto-session").setup({
        auto_session_root_dir = os.getenv("HOME") .. "/" .. ".neovim_sessions/",
        auto_session_enable_last_session = false,
        auto_session_create_enabled = false,
        auto_session_suppress_dirs = { "~/", "~/Downloads/", "/" },
        session_lens = {
            buftypes_to_ignore = {},
            load_on_setup = true,
            theme_conf = { border = true },
            prompt_title = "Projects",
        },
    })
end

local function autopairs()
    add({ source = "windwp/nvim-autopairs" })
    prequire('plugins.autopairs')
end

local function dial()
    add({ source = "monaqa/dial.nvim" })
    prequire("plugins.dial")
end

local function colorizer()
    add({ source = "NvChad/nvim-colorizer.lua" })
    prequire("plugins.colorizer")
end

local function textobjects()
    add({
        source = "chrisgrieser/nvim-various-textobjs"
    })
    add({
        source = "wellle/targets.vim"
    })
    local map = vim.keymap.set
    local modes = { "o", "x" }
    -- indentation
    map(modes, "ii", function() require("various-textobjs").indentation(true, true) end)
    map(modes, "ai", function() require("various-textobjs").indentation(false, true) end)

    -- values, e.g. variable assignment
    map(modes, "iv", function() require("various-textobjs").value(true) end)
    map(modes, "av", function() require("various-textobjs").value(false) end)
end

local function formatting()
    add({ source = "stevearc/conform.nvim" })
    prequire("plugins.conform")
end

local function neogit()
    add({
        source = "NeogitOrg/neogit",
        depends = {
            "nvim-lua/plenary.nvim",         -- required
            "sindrets/diffview.nvim",        -- optional - Diff integration
            "nvim-telescope/telescope.nvim", -- optional
            "nvim-tree/nvim-web-devicons"    -- icons
        }
    })
    prequire('neogit').setup({
        integrations = {
            telescope = true,
            diffview = true,
        },
        disable_insert_on_commit = true,
        kind = "replace",
        graph_style = "unicode"
    })
    vim.keymap.set("n", "<leader>gs", "<cmd>Neogit<CR>", {
        desc = "Neogit"
    })
end

local function markdown()
    add({ source = "MeanderingProgrammer/render-markdown.nvim" })
    add({ source = "epwalsh/obsidian.nvim" })
    prequire('plugins.markdown')
end

local function whichkey()
    add({
        source = "folke/which-key.nvim",
    })
    prequire('plugins.whichkey')
end

local function telescope()
    add({
        source = "nvim-telescope/telescope.nvim",
        depends = {
            "nvim-lua/plenary.nvim"
        }
    })
    prequire('plugins.telescope')
end

local function dressing()
    add({
        source = "stevearc/dressing.nvim"
    })
    prequire('plugins.dressing')
end

local function gitsigns()
    add({ source = "lewis6991/gitsigns.nvim" })
    prequire('plugins.gitsigns')
end

local function barbecue()
    add({
        source = "utilyre/barbecue.nvim",
        depends = {
            "SmiteshP/nvim-navic",
            "echasnovski/mini.icons"
        }
    })
    prequire('barbecue').setup()
end

local function copilot()
    add({
        source = "CopilotC-Nvim/CopilotChat.nvim",
        checkout = "canary",
        depends = {
            "zbirenbaum/copilot.lua"
        },
        hooks = {
            post_checkout = function(args)
                vim.system({ 'make', 'tiktoken' }, {
                    cwd = args.path
                })
            end
        }
    })
    prequire('plugins.copilot')
end

local function hop()
    add({
        source = "smoka7/hop.nvim",
        checkout = "*"
    })
    prequire("plugins.hop")
end

now(function()
    require('globals')
    prequire('options')
    prequire('guiopts')
    prequire('ui')
    statuscol()
    colorscheme()
    dressing()
    hop()
    barbecue()
    mini()
    blink()
    lsp()
    autopairs()
    dial()
    telescope()
end)

later(function()
    prequire('keybinds')
    prequire('autocmds')
    snacks()
    nvim_tmux_nav()
    session_manager()
    copilot()
    textobjects()
    colorizer()
    lua_console()
    treesitter()
    formatting()
    gitsigns()
    neogit()
    markdown()
    whichkey()
end)
