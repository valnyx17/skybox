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
        vim.fn.matchadd("WarnHint", "\\( WARN:\\)")
    end
})
