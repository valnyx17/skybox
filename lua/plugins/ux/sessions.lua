return {
    "olimorris/persisted.nvim",
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
    }
}
