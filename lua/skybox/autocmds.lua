local api = vim.api
local fn = vim.fn
local au = api.nvim_create_autocmd
local aug = function(name, fnc)
  fnc(api.nvim_create_augroup(name, { clear = true }))
end

aug("rc/filetype-opts", function(g)
  au("FileType", {
    pattern = { "json", "jsonc" },
    group = g,
    callback = function()
      vim.wo.conceallevel = 0
    end
  })

  au("FileType", {
    group = g,
    callback = function(event)
      vim.bo[event.buf].buflisted = false
    end,
    pattern = { "man" }
  })

  au("FileType", {
    group = g,
    callback = function()
      vim.opt_local.formatoptions:remove({ "o" })
    end
  })

  au("FileType", {
    group = g,
    desc = "automatically split help buffers to the right",
    pattern = "help",
    command = "wincmd L"
  })
end)

aug("rc/terminal", function(g)
  au("TermOpen", {
    group = g,
    pattern = "term://*",
    callback = function(event)
      if vim.opt.buftype:get() == "terminal" then
        local set = vim.opt_local
        set.number = false
        set.relativenumber = false
        set.signcolumn = "no"
        set.scrolloff = 0
        vim.opt.filetype = "terminal"

        vim.cmd.startinsert()
      end
    end
  })
end)

-- https://www.reddit.com/r/neovim/comments/1i2xw2m/comment/m7qfir5
aug("rc/filetype-quit", function(g)
  au({ 'BufEnter' }, {
    group = g,
    callback = function(event)
      local bufnr = event.buf
      local filetype = vim.bo[bufnr].filetype
      local types = {
        ["PlenaryTestPopup"] = true,
        ["checkhealth"] = true,
        ["fugitive"] = true,
        ["vim"] = true,
        ["dbout"] = true,
        ["gitsigns-blame"] = true,
        ["grug-far"] = true,
        ["help"] = true,
        ["lspinfo"] = true,
        ["neotest-output"] = true,
        ["neotest-output-panel"] = true,
        ["neotest-summary"] = true,
        ["notify"] = true,
        ["qf"] = true,
        ["snacks_win"] = true,
        ["spectre_panel"] = true,
        ["startuptime"] = true,
        ["tsplayground"] = true,
      }
      if fn.has_key(types, filetype) == 1 or filetype == "" then
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'q', '', {
          callback = function()
            api.nvim_command("close")
            pcall(api.nvim_buf_delete, event.buf, { force = true })
          end
        })
      end
    end
  })
end)

aug("rc/set-cwd", function(g)
  au("VimEnter", {
    group = g,
    pattern = { "*" },
    callback = function()
      api.nvim_set_current_dir(fn.expand("%:p:h"))
    end
  })
end)

aug("rc/equalize-splits", function(g)
  au("VimResized", {
    group = g,
    desc = "resize splits with terminal window",
    callback = function()
      local current_tab = api.nvim_get_current_tabpage()
      vim.cmd("tabdo wincmd =")
      api.nvim_set_current_tabpage(current_tab)
    end
  })
end)

aug("rc/auto-++p", function(g)
  -- :h ++p
  au({ "BufWritePre", "FileWritePre" }, {
    group = g,
    callback = function(event)
      if not event.match:match("^%w%w+:[\\/][\\/]") then
        local file = vim.uv.fs_realpath(event.match) or event.match
        fn.mkdir(fn.fnamemodify(file, ":p:h"), "p")
      end
    end,
  })
end)

if fn.exists(":TinyGlimmer") ~= 0 then
  aug("rc/tiny-glimmer", function(g)
    au("CmdlineLeave", {
      group = g,
      desc = "TinyGlimmer search",
      callback = function()
        local cmd_type = fn.getcmdtype()
        if cmd_type == "/" or cmd_type == "?" then
          require('skybox.util').animated_search(nil, fn.getreg("/"))
        end
      end
    })
  end)
end

aug("rc/cmdline", function(g)
  au("CmdlineEnter", {
    group = g,
    desc = "Don't hide the cmdline when typing a command",
    command = ":set cmdheight=1 | redrawstatus"
  })
  au("CmdlineLeave", {
    group = g,
    desc = "Hide cmdline when not typing a command",
    command = ":set cmdheight=0 | redrawstatus",
  })
  au("BufWritePost", {
    group = g,
    desc = "get rid of message after writing a file",
    pattern = { '*' },
    command = "redrawstatus"
  })
end)

aug("rc/toggle-search-hl", function(g)
  au("InsertEnter", {
    group = g,
    callback = function()
      vim.schedule(function() vim.cmd("nohlsearch") end)
    end
  })

  au("CursorMoved", {
    group = g,
    callback = function()
      -- no bloat lua adaptation of: https://github.com/romainl/vim-cool
      local view, rpos = fn.winsaveview(), fn.getpos(".")
      -- Move the cursor to a position where (whereas in active search) pressing `n`
      -- brings us to the original cursor position, in a forward search / that means
      -- one column before the match, in a backward search ? we move one col forward
      vim.cmd(string.format("silent! keepjumps go%s",
        (fn.line2byte(view.lnum) + view.col + 1 - (vim.v.searchforward == 1 and 2 or 0))))
      -- Attempt to goto next match, if we're in an active search cursor position
      -- should be equal to original cursor position
      local ok, _ = pcall(vim.cmd, "silent! keepjumps norm! n")
      local insearch = ok and (function()
        local npos = fn.getpos(".")
        return npos[2] == rpos[2] and npos[3] == rpos[3]
      end)()
      -- restore original view and position
      fn.winrestview(view)
      if not insearch then
        vim.schedule(function() vim.cmd("nohlsearch") end)
      end
    end
  })
end)

aug("rc/sticky-yank", function(g)
  local keymap = require("skybox.util.keymap")
  local cursorPreYank
  keymap.set({ "n", "x" }, "y", function()
    cursorPreYank = api.nvim_win_get_cursor(0)
    return "y"
  end, { expr = true })
  keymap.set({ "n", "x" }, "Y", function()
    cursorPreYank = api.nvim_win_get_cursor(0)
    return "yg_"
  end, { expr = true })
  au("TextYankPost", {
    group = g,
    callback = function()
      if vim.v.event.operator == "y" and cursorPreYank then
        api.nvim_win_set_cursor(0, cursorPreYank)
      end
    end
  })
end)

aug("rc/cursorline-only-on-active-windows", function(g)
  au({ "InsertLeave", "WinEnter" }, {
    group = g,
    callback = function()
      if vim.w.auto_cursorline then
        vim.wo.cursorline = true
        vim.w.auto_cursorline = false
      end
    end
  })

  au({ "InsertEnter", "WinLeave" }, {
    group = g,
    callback = function()
      if vim.wo.cursorline then
        vim.w.auto_cursorline = true
        vim.wo.cursorline = false
      end
    end
  })
end)

-- https://www.reddit.com/r/neovim/comments/1i2xw2m/comment/m7jbnnf
aug("rc/scrolleof", function(g)
  au({ "CursorMoved", "CursorMovedI", "WinScrolled" }, {
    desc = "Fix scrolloff when you are at the EOF",
    group = g,
    callback = function()
      if api.nvim_win_get_config(0).relative ~= "" then
        return -- Ignore floating windows
      end

      local win_height = fn.winheight(0)
      local scrolloff = math.min(vim.o.scrolloff, math.floor(win_height / 2))
      local visual_distance_to_eof = win_height - fn.winline()

      if visual_distance_to_eof < scrolloff then
        local win_view = fn.winsaveview()
        fn.winrestview({ topline = win_view.topline + scrolloff - visual_distance_to_eof })
      end
    end,
  })
end)

aug("rc/two-space-indents", function(g)
  au("FileType", {
    group = g,
    desc = "set tabwidths to 2 on certain files",
    pattern = {
      "nix",
      "lua",
      "cpp",
      "c"
    },
    callback = function()
      local setlocal = vim.opt_local
      setlocal.tabstop = 2
      setlocal.vartabstop = "2"
    end
  })
end)

aug("rc/fuck-q:", function(g)
  au("CmdWinEnter", {
    group = g,
    pattern = "*",
    command = "quit"
  })
end)

aug("rc/textwidth", function(g)
  -- set wrap if window is less than textwidth
  au("WinResized", {
    pattern = '*',
    callback = function()
      local win_width = api.nvim_win_get_width(0)
      local text_width = vim.opt.textwidth._value
      local wide_enough = win_width < text_width + 1
      api.nvim_set_option_value('wrap', wide_enough, {})
    end
  })
end)

-- aug("rc/auto-change-lcd", function(g)
--   au("BufWinEnter", {
--     group = g,
--     desc = "auto change local current directory",
--     callback = function (args)
--       if api.nvim_get_option_value("buftype", { buf = args.buf }) ~= "" then return end
--       local root = vim.fs.root(args.buf, function (name, path)
--         local pattern = { ".git",  "Cargo.toml", "go.mod", "deno.json", "deno.jsonc" }
--         local multipattern = { "build/compile_commands.json" }
--         local abspath = { fn.stdpath("config") }
--         local parentpath = { "~/.config", "~/prj", "~/Documents/code" }
--
--         return vim.iter(pattern):any(function (filepat)
--           return filepat == name
--         end) or vim.iter(multipattern):any(function (filepats)
--           return vim.uv.fs_stat(vim.fs.joinpath(path, vim.fs.normalize(filepats)))
--         end) or vim.iter(abspath):any(function (dirpath)
--           return vim.fs.normalize(dirpath) == path
--         end) or vim.iter(parentpath):any(function (ppath)
--           return vim.fs.normalize(ppath) == vim.fs.dirname(path)
--         end)
--       end)
--       if root then
--         vim.cmd.lcd(root)
--       end
--     end
--   })
-- end)
