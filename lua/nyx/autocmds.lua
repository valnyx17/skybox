local autocmds = {}

-- a function to create a function that creates autocmds for an augroup
function autocmds.create_wrapper(augroup_name)
    local augroup = vim.api.nvim_create_augroup(augroup_name, { clear = true })
    return function(event, opts)
            opts.group = opts.group or augroup
            return vim.api.nvim_create_autocmd(event, opts)
        end,
        augroup
end

autocmds.create, autocmds.augroup = autocmds.create_wrapper("editor")

autocmds.create({ "FileType" }, {
    pattern = { "json", "jsonc" },
    callback = function()
        vim.wo.conceallevel = 0
    end,
})

-- Create highlight groups for comment patterns
vim.api.nvim_set_hl(0, 'TdoHint', { fg = "#0B0B0B", bg = "#89dceb" })
vim.api.nvim_set_hl(0, 'NoteHint', { fg = "#0B0B0B", bg = "#faa7e7" })
vim.api.nvim_set_hl(0, 'BugHint', { fg = "#0B0B0B", bg = "#B03060" })
vim.api.nvim_set_hl(0, 'WarnHint', { fg = "#0B0B0B", bg = "#E17862" })

autocmds.create({ 'BufEnter', 'BufWritePre' }, {
    callback = function()
        vim.fn.matchadd("TdoHint", "\\( TODO:\\)")
        vim.fn.matchadd("NoteHint", "\\( NOTE:\\)")
        vim.fn.matchadd("BugHint", "\\( BUG:\\)")
        vim.fn.matchadd("BugHint", "\\( [xX]\\{3\\}:\\)")
        vim.fn.matchadd("BugHint", "\\( FIXME:\\)")
        vim.fn.matchadd("WarnHint", "\\( WARN:\\)")
    end
})

autocmds.create("FileType", {
    callback = function()
        vim.opt_local.formatoptions:remove({ "o" })
    end
})

-- autocd if given a directory
autocmds.create("VimEnter", {
    pattern = "*",
    callback = function()
        vim.api.nvim_set_current_dir(vim.fn.expand("%:p:h"))
    end
})

-- resize splits if window got resized
autocmds.create({ "VimResized" }, {
    callback = function()
        local current_tab = vim.fn.tabpagenr()
        vim.cmd("tabdo wincmd =")
        vim.cmd("tabnext " .. current_tab)
    end,
})

autocmds.create("FileType", {
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
    callback = function(event)
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
})

-- make it easier to close man-files when opened inline
autocmds.create("FileType", {
    pattern = { "man" },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
    end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
autocmds.create({ "BufWritePre" }, {
    callback = function(event)
        if event.match:match("^%w%w+:[\\/][\\/]") then
            return
        end
        local file = vim.uv.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
})
