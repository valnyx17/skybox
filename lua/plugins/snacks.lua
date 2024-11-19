require("snacks").setup({
    bigfile = { enabled = true },
    notifier = {
        enabled = true,
        timeout = 3000
    },
    quickfile = { enabled = true },
    -- statuscolumn = { enabled = false },
    words = { enabled = true },
    styles = {
        notification = {
            wo = { wrap = true }
        }
    },
    dashboard = {
        enabled = true,
        sections = {
            { section = "header" },
            {
                pane = 2,
                section = "terminal",
                cmd = "colorscript -e square",
                height = 5,
                padding = 1
            },
            { section = "keys",  gap = 1,                       padding = 1 },
            { pane = "2",        icon = tools.ui.icons.file,    title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
            { pane = "2",        icon = tools.ui.icons.diamond, title = "Projects",     section = "projects",     indent = 2, padding = 1 },
        }
    }
})

-- setup some globals for debugging
_G.dd = function(...)
    Snacks.debug.inspect(...)
end
_G.bt = function(...)
    Snacks.debug.backtrace(...)
end
vim.print = _G.dd

-- stylua: ignore start
vim.keymap.set("n", "<leader>un", function() Snacks.notifier.hide() end, { desc = "Dismiss All Notifications" })
vim.keymap.set("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete Buffer" })
vim.keymap.set("n", "<leader>lg", function() Snacks.lazygit() end, { desc = "Lazygit" })
vim.keymap.set("n", "<leader>gb", function() Snacks.git.blame_line() end, { desc = "Git Blame Line" })
vim.keymap.set("n", "<leader>gB", function() Snacks.gitbrowse() end, { desc = "Git Browse" })
vim.keymap.set("n", "<leader>lf", function() Snacks.lazygit.log_file() end, { desc = "Lazygit Current File History" })
vim.keymap.set("n", "<leader>gl", function() Snacks.lazygit.log() end, { desc = "Lazygit Log (cwd)" })
vim.keymap.set("n", "<leader>cr", function() Snacks.rename() end, { desc = "Rename File" })
vim.keymap.set({"n", "t"}, "<c-,>", function() Snacks.terminal.toggle() end, { desc = "Toggle Terminal" })
vim.keymap.set({ "n", "t" }, "]]", function() Snacks.words.jump(vim.v.count1) end, { desc = "Next Reference" })
vim.keymap.set({ "n", "t" }, "[[", function() Snacks.words.jump(-vim.v.count1) end, { desc = "Prev Reference" })
-- stylua: ignore end
--
vim.keymap.set({ "n", "t" }, "<leader>tf", function()
    Snacks.terminal(nil, { win = { position = "float" } })
end, { silent = true, desc = "[T]erminal [F]loat" })

vim.keymap.set({ "n", "t" }, "<leader>tv", function()
    Snacks.terminal(nil, { win = { position = "right" } })
end, { silent = true, desc = "[T]erminal [V]ertical" })

vim.keymap.set({ "n", "t" }, "<leader>th", function()
    Snacks.terminal(nil, { win = { position = "bottom" } })
end, { silent = true, desc = "[T]erminal [H]orizontal" })

vim.keymap.set("n", "<leader>N", function()
    Snacks.win({
        file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
        width = 0.6,
        height = 0.6,
        wo = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
        },
    })
end, { desc = "Neovim News" })

vim.api.nvim_create_autocmd("User", {
    pattern = "MiniFilesActionRename",
    callback = function(event)
        Snacks.rename.on_rename_file(event.data.from, event.data.to)
    end,
})

-- Create some toggle mappings
Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
Snacks.toggle.diagnostics():map("<leader>ud")
Snacks.toggle.line_number():map("<leader>ul")
Snacks.toggle
    .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
    :map("<leader>uc")
Snacks.toggle.treesitter():map("<leader>uT")
Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
Snacks.toggle.inlay_hints():map("<leader>uh")
