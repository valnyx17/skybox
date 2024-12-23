-- return {
--     "rose-pine/neovim",
--     event = "UiEnter",
--     name = "rose-pine",
--     opts = {
--         highlight_groups = {
--             StatusVisual = { bg = "iris", fg = "base" },
--             StatusReplace = { bg = "love", fg = "base" },
--             StatusInsert = { bg = "foam", fg = "base" },
--             StatusCommand = { bg = "text", fg = "base" },
--             StatusNormal = { bg = "leaf", fg = "base" },
--             StatusTerminal = { bg = "text", fg = "base" },
--             StatusNormalO = { bg = "base", fg = "pine" },
--
--             CursorLineNr = { fg = "text", bg = "base" },
--             Visual = { bg = "highlight_low" },
--             String = { fg = "leaf" },
--             ["@property"] = { fg = "text" },
--             CursorLine = { bg = "surface" },
--             ModeMsg = { fg = "overlay" },
--
--             MiniJump = { undercurl = true, sp = "love" },
--             MiniJump2dSpot = { fg = "love" },
--             MiniJump2dSpotUnique = { fg = "leaf" },
--             MiniJump2dSpotAhead = { fg = "pine" },
--
--             TelescopeBorder = { fg = "overlay", bg = "overlay" },
--             TelescopeNormal = { fg = "subtle", bg = "overlay" },
--             TelescopeSelection = { fg = "text", bg = "highlight_med" },
--             TelescopeSelectionCaret = { fg = "love", bg = "highlight_med" },
--             TelescopeMultiSelection = { fg = "text", bg = "highlight_high" },
--
--             TelescopeTitle = { fg = "base", bg = "love" },
--             TelescopePromptTitle = { fg = "base", bg = "pine" },
--             TelescopePreviewTitle = { fg = "base", bg = "iris" },
--
--             TelescopePromptNormal = { fg = "text", bg = "surface" },
--             TelescopePromptBorder = { fg = "surface", bg = "surface" },
--
--             CurSearch = { fg = "base", bg = "leaf", inherit = false },
--             Search = { fg = "text", bg = "leaf", blend = 20, inherit = false },
--
--             PmenuMatchSel = { bg = "overlay", bold = true }
--         }
--     },
--     config = function(_, opts)
--         require('rose-pine').setup(opts)
--         if vim.o.background == "light" then
--             vim.cmd([[colorscheme rose-pine-dawn]])
--         else
--             vim.cmd([[colorscheme rose-pine]])
--         end
--     end
-- }
local M = { "rebelot/kanagawa.nvim" }

M.event = "UiEnter"

M.opts = {
    compile = false, -- enable compiling the colorscheme
    undercurl = true, -- enable undercurls
    commentStyle = { italic = true },
    functionStyle = {},
    keywordStyle = { italic = true },
    statementStyle = { bold = true },
    typeStyle = {},
    transparent = false, -- do not set background color
    dimInactive = false, -- dim inactive window `:h hl-NormalNC`
    terminalColors = true, -- define vim.g.terminal_color_{0,17}
    colors = { -- add/modify theme and palette colors
        palette = {},
        theme = {
            all = {
                ui = {
                    bg_gutter = "none",
                },
            },
        },
    },
    overrides = function(colors) -- add/modify highlights
        local theme = colors.theme
        return {
            TelescopeTitle = { fg = theme.ui.special, bold = true },
            TelescopePromptNormal = { bg = theme.ui.bg_p1 },
            TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
            TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
            TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
            TelescopePreviewNormal = { bg = theme.ui.bg_dim },
            TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },

            Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 }, -- add `blend = vim.o.pumblend` to enable transparency
            PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
            PmenuSbar = { bg = theme.ui.bg_m1 },
            PmenuThumb = { bg = theme.ui.bg_p2 },
        }
    end,
    theme = "dragon", -- Load "dragon" theme when 'background' option is not set
    background = { -- map the value of 'background' option to a theme
        dark = "dragon",
        light = "lotus",
    },
}

M.config = function(_, opts)
    require("kanagawa").setup(opts)
    vim.cmd([[colorscheme kanagawa]])
end

return M
