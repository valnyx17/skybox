return {
    "stevearc/oil.nvim",
    cmd = { "Oil" },
    keys = {
        { "<leader>fd", "<cmd>Oil<CR>", desc = "dired" }
    },
    dependencies = {
        { "SirZenith/oil-vcs-status" }
    },
    config = function()
        require("oil").setup({
            view_options = {
                show_hidden = true,
            },
            default_file_explorer = true,
            skip_confirm_for_simple_edits = true,
            keymaps = {
                ["gd"] = {
                    desc = "Toggle file detail view",
                    callback = function()
                        detail = not detail
                        if detail then
                            require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
                        else
                            require("oil").set_columns({ "icon" })
                        end
                    end,
                },
                ["<C-s>"] = {},
                ["<C-v>"] = {
                    "actions.select",
                    opts = { vertical = true },
                },
            }
        })

        local status_const = require("oil-vcs-status.constant.status")
        local StatusType = status_const.StatusType

        require("oil-vcs-status").setup({
            [StatusType.Added] = "",
            [StatusType.Copied] = "󰆏",
            [StatusType.Deleted] = "",
            [StatusType.Ignored] = "",
            [StatusType.Modified] = "",
            [StatusType.Renamed] = "",
            [StatusType.TypeChanged] = "󰉺",
            [StatusType.Unmodified] = " ",
            [StatusType.Unmerged] = "",
            [StatusType.Untracked] = "",
            [StatusType.External] = "",

            [StatusType.UpstreamAdded] = "󰈞",
            [StatusType.UpstreamCopied] = "󰈢",
            [StatusType.UpstreamDeleted] = "",
            [StatusType.UpstreamIgnored] = " ",
            [StatusType.UpstreamModified] = "󰏫",
            [StatusType.UpstreamRenamed] = "",
            [StatusType.UpstreamTypeChanged] = "󱧶",
            [StatusType.UpstreamUnmodified] = " ",
            [StatusType.UpstreamUnmerged] = "",
            [StatusType.UpstreamUntracked] = " ",
            [StatusType.UpstreamExternal] = "",
            tatus_symbol = {
            }
        })
    end
}
