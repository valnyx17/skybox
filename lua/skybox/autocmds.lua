local rc = vim.api.nvim_create_augroup("rc", {
    clear = true
})
local au = vim.api.nvim_create_autocmd

vim.api.nvim_set_hl(0, "TodoHint", { fg = "#0B0B0B", bg = "#89dceb" })
vim.api.nvim_set_hl(0, "NoteHint", { fg = "#0B0B0B", bg = "#faa7e7" })
vim.api.nvim_set_hl(0, "BugHint", { fg = "#0B0B0B", bg = "#B03060" })
vim.api.nvim_set_hl(0, "WarnHint", { fg = "#0B0B0B", bg = "#E17862" })

au("FileType", {
  pattern = { "json", "jsonc" },
  group = rc,
  callback = function()
    vim.wo.conceallevel = 0
  end
})

au("FileType", {
  group = rc,
  callback = function()
    vim.opt_local.formatoptions:remove({ "o" })
  end
})

au("VimEnter", {
  group = rc,
  pattern = { "*" },
  callback = function()
    vim.api.nvim_set_current_dir(vim.fn.expand("%:p:h"))
  end
})

au("VimResized", {
  group = rc,
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end
})

au("FileType", {
  group = rc,
  pattern =  {
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
      desc = "Quit Buffer"
    })
  end)
  end
})

au("FileType", {
  group = rc,
  callback = function(event)
    vim.bo[event.buf].buflisted = false
  end,
  pattern = { "man" }
})

au("BufWritePre", {
  group = rc,
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

au({"BufEnter", "BufWritePre"}, {
  group = rc,
  callback = function(event)
    vim.fn.matchadd("TodoHint", "\\( TODO:\\)")
    vim.fn.matchadd("NoteHint", "\\( NOTE:\\)")
    vim.fn.matchadd("BugHint", "\\( BUG:\\)")
    vim.fn.matchadd("BugHint", "\\( [xX]\\{3\\}:\\)")
    vim.fn.matchadd("BugHint", "\\( FIXME:\\)")
    vim.fn.matchadd("WarnHint", "\\( WARN:\\)")
  end,
})

-- :h ++p
au({"BufWritePre", "FileWritePre"}, {
  group = rc,
  pattern = "*",
  callback = function(event)
    if event.file:find("\\(://\\)") ~= nil then
      vim.fn.mkdir(vim.fn.expand(event.file .. ":p:h"))
    end
  end
})
