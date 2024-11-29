return {
    "olimorris/persisted.nvim",
    keys = {
        { "<localleader>ss", "<cmd>SessionSave<cr>",         desc = "save current session" },
        { "<localleader>sl", "<cmd>SessionLoad<cr>",         desc = "load current session" },
        { "<localleader>so", "<cmd>Telescope persisted<cr>", desc = "select a session" },
    },
    opts = {
        save_dir = os.getenv("HOME") .. "/" .. ".neovim_sessions/",
        autoload = false,
        use_git_branch = true,
        should_save = function()
            if vim.bo.filetype == "snacks_dashboard" then
                return false
            end
            return true
        end,
        ignored_dirs = {
            "~/Downloads",
            "~/.config"
        }
    },
    config = function(_, opts)
        require("persisted").setup(opts)
        require("telescope").load_extension("persisted")
    end
}
