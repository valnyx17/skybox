---
-- @file lua/sky/init.lua
--
-- @brief
-- entry point for non-plugin configuration
--
-- @author valnyx
--

return {
    setup = function()
        vim.api.nvim_create_autocmd("UiEnter", {
            once = true,
            callback = function()
                require("sky.opts").setup()
                -- require('sky.ui.statusline')
                -- require('sky.ui.statuscolumn')
                require("sky.ui")
            end,
        })
        vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            callback = function()
                require("sky.keymaps").setup()
                require("sky.commands").setup()
                require("sky.autocmds").setup()
            end,
        })
    end,
}
