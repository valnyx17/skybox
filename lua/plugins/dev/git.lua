return {
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                attach_to_untracked = false,
                preview_config = {
                    border = v.ui.cur_border,
                    style = 'minimal',
                    relative = 'cursor',
                    row = 0,
                    col = 1
                },
                signs =
                {
                    add = {
                        -- hl = "GitSignsAdd",
                        -- culhl = "GitSignsAddCursorLine",
                        -- numhl = "GitSignsAddNum",
                        text = v.ui.git.icons.add,
                    }, -- alts: ▕, ▎, ┃, │, ▌, ▎ 🮉
                    change = {
                        -- hl = "GitSignsChange",
                        -- culhl = "GitSignsChangeCursorLine",
                        -- numhl = "GitSignsChangeNum",
                        text = v.ui.git.icons.change,
                    }, -- alts: ▎║▎
                    delete = {
                        -- hl = "GitSignsDelete",
                        -- culhl = "GitSignsDeleteCursorLine",
                        -- numhl = "GitSignsDeleteNum",
                        text = v.ui.git.icons.delete,
                    }, -- alts: ┊▎▎
                    topdelete = {
                        -- hl = "GitSignsDelete",
                        text = v.ui.git.icons.topdelete,
                    }, -- alts: ▌ ▄▀
                    changedelete = {
                        -- hl = "GitSignsChange",
                        text = v.ui.git.icons.changedelete,
                    }, -- alts: ▌
                    untracked = {
                        -- hl = "GitSignsAdd",
                        text = v.ui.git.icons.untracked,
                    }, -- alts: ┆ ▕
                    signs_staged = {
                        change = { text = "┋" },
                        delete = { text = "🢒" },
                    },
                },
                signcolumn = true,
                update_debounce = 500,
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns

                    local function map(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                    end

                    map('n', '<leader>gb', function() gs.blame_line({ full = false }) end, { desc = "show line blame" })
                    map('n', '<leader>gd', gs.diffthis, { desc = "gitsigns diffthis" })
                    map('n', '<leader>gD', function() gs.diffthis('~') end, { desc = "gitsigns diffthis ~" })
                    map("n", "<leader>gt", gs.toggle_signs, { desc = "gitsigns toggle signs" })
                    map("n", "<leader>hp", gs.preview_hunk, { desc = "gitsigns preview hunk" })
                    map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "gitsigns undo stage hunk" })

                    map({ "n", "v" }, "<leader>hs", ':Gitsigns stage_hunk<CR>', { desc = "stage hunk" })
                    map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>', { desc = "reset hunk" })

                    for map_str, fn in pairs({
                        ["]h"] = gs.next_hunk,
                        ["[h"] = gs.prev_hunk
                    }) do
                        map('n', map_str, function()
                            if vim.wo.diff then return map_str end
                            vim.schedule(function() fn() end)
                            return '<Ignore>'
                        end, { expr = true })
                    end
                end
            })
        end
    },
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",         -- required
            "sindrets/diffview.nvim",        -- optional - Diff integration
            "nvim-telescope/telescope.nvim", -- optional
            "nvim-tree/nvim-web-devicons"    -- icons
        },
        opts = {
            integrations = {
                telescope = true,
                diffview = true,
            },
            disable_commit_confirmation = true,
            disable_signs = false,
            disable_hint = true,
            disable_builtin_notifications = true,
            disable_insert_on_commit = true,
            signs = {
                section = { "", "" }, -- "󰁙", "󰁊"
                item = { "▸", "▾" },
                hunk = { "󰐕", "󰍴" },
            },
            kind = "replace",
            graph_style = "unicode"
        },
        keys = {
            { "<leader>gs", "<cmd>Neogit<cr>", desc = "Neogit" }
        }
    },
    {
        "f-person/git-blame.nvim",
        cmd = {
            "GitBlameOpenCommitURL",
            "GitBlameOpenFileURL",
            "GitBlameCopyCommitURL",
            "GitBlameCopyFileURL",
            "GitBlameCopySHA",
        },
        keys = {
            { "<localleader>gB", "<Cmd>GitBlameOpenCommitURL<CR>", desc = "git blame: open commit url", mode = "n" },
        },
        init = function() vim.g.gitblame_enabled = 0 end,
    }
}
