vim.api.nvim_set_hl(0, "TdoHint", { fg = "#0B0B0B", bg = "#89dceb" })
vim.api.nvim_set_hl(0, "NoteHint", { fg = "#0B0B0B", bg = "#faa7e7" })
vim.api.nvim_set_hl(0, "BugHint", { fg = "#0B0B0B", bg = "#B03060" })
vim.api.nvim_set_hl(0, "WarnHint", { fg = "#0B0B0B", bg = "#E17862" })

return {
    setup = function()
        require("legendary").autocmds({
            {
                "FileType",
                function()
                    vim.wo.conceallevel = 0
                end,
                opts = {
                    pattern = { "json", "jsonc" },
                },
            },
            {
                "FileType",
                function()
                    vim.opt_local.formatoptions:remove({ "o" })
                end,
            },
            {
                "VimEnter",
                function()
                    vim.api.nvim_set_current_dir(vim.fn.expand("%:p:h"))
                end,
                opts = {
                    pattern = { "*" },
                },
            },
            {
                "VimResized",
                function()
                    local current_tab = vim.fn.tabpagenr()
                    vim.cmd("tabdo wincmd =")
                    vim.cmd("tabnext " .. current_tab)
                end,
            },
            {
                "FileType",
                function(event)
                    vim.bo[event.buf].buflisted = false
                    vim.schedule(function()
                        vim.keymap.set("n", "q", function()
                            vim.cmd("close")
                            pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
                        end, {
                            buffer = event.buf,
                            silent = true,
                            desc = "Quit buffer",
                        })
                    end)
                end,
                opts = {
                    pattern = {
                        "PlenaryTestPopup",
                        "checkhealth",
                        "dbout",
                        "gitsigns-blame",
                        "grug-far",
                        "help",
                        "lspinfo",
                        "neotest-output",
                        "neotest-output-panel",
                        "neotest-summary",
                        "notify",
                        "qf",
                        "snacks_win",
                        "spectre_panel",
                        "startuptime",
                        "tsplayground",
                    },
                },
            },
            {
                "FileType",
                function(event)
                    vim.bo[event.buf].buflisted = false
                end,
                opts = {
                    pattern = { "man" },
                },
            },
            {
                "BufWritePre",
                function(event)
                    if event.match:match("^%w%w+:[\\/][\\/]") then
                        return
                    end
                    local file = vim.uv.fs_realpath(event.match) or event.match
                    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
                end,
            },
            {
                { "BufEnter", "BufWritePre" },
                function()
                    vim.fn.matchadd("TdoHint", "\\( TODO:\\)")
                    vim.fn.matchadd("NoteHint", "\\( NOTE:\\)")
                    vim.fn.matchadd("BugHint", "\\( BUG:\\)")
                    vim.fn.matchadd("BugHint", "\\( [xX]\\{3\\}:\\)")
                    vim.fn.matchadd("BugHint", "\\( FIXME:\\)")
                    vim.fn.matchadd("WarnHint", "\\( WARN:\\)")
                end,
            },
        })
    end,
}
