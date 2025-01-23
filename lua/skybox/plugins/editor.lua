local util = Skybox.ui
return {
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    -- icon support
    dependencies = { "echasnovski/mini.icons" },
    opts = function(_, opts)
      local fzf = require('fzf-lua')
      local config = fzf.config
      local actions = fzf.actions

      -- Quickfix
      config.defaults.keymap.fzf["ctrl-q"] = "select-all+accept"
      config.defaults.keymap.fzf["ctrl-u"] = "half-page-up"
      config.defaults.keymap.fzf["ctrl-d"] = "half-page-down"
      config.defaults.keymap.fzf["ctrl-x"] = "jump"
      config.defaults.keymap.fzf["ctrl-f"] = "preview-page-down"
      config.defaults.keymap.fzf["ctrl-b"] = "preview-page-up"
      config.defaults.keymap.builtin["<c-f>"] = "preview-page-down"
      config.defaults.keymap.builtin["<c-b>"] = "preview-page-up"


      -- Toggle root dir / cwd
      config.defaults.actions.files["ctrl-r"] = function(_, ctx)
        local o = vim.deepcopy(ctx.__call_opts)
        o.root = o.root == false
        o.cwd = nil
        o.buf = ctx.__CTX.bufnr
        Skybox.pick.open(ctx.__INFO.cmd, o)
      end
      config.defaults.actions.files["alt-c"] = config.defaults.actions.files["ctrl-r"]
      config.set_action_helpstr(config.defaults.actions.files["ctrl-r"], "toggle-root-dir")
      return {
        "default-title",
        fzf_colors = true,
        fzf_opts = {
          ["--no-scrollbar"] = true,
        },
        defaults = {
          -- formatter = "path.filename_first",
          formatter = "path.dirname_first",
        },
        winopts = {
          width = 0.8,
          height = 0.8,
          row = 0.5,
          col = 0.5,
          preview = {
            scrollchars = { "┃", "" },
            border = util.borders.empty,
          },
          border = util.borders.empty,
        },
        files = {
          cwd_prompt = false,
          actions = {
            ["alt-i"] = { actions.toggle_ignore },
            ["alt-h"] = { actions.toggle_hidden },
          },
        },
        grep = {
          actions = {
            ["alt-i"] = { actions.toggle_ignore },
            ["alt-h"] = { actions.toggle_hidden },
          },
        },
        lsp = {
          symbols = {
            symbol_hl = function(s)
              return "TroubleIcon" .. s
            end,
            symbol_fmt = function(s)
              return s:lower() .. "\t"
            end,
            child_prefix = false,
          },
          code_actions = {
            previewer = vim.fn.executable("delta") == 1 and "codeaction_native" or nil,
          },
        },
      }
    end,
    keys = {
      -- find
      { "<leader>fb", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
      { "<leader>fc", Skybox.pick.config_files(),                                 desc = "Find Config File" },
      { "<leader>ff", Skybox.pick("files"),                                       desc = "Find Files (Root Dir)" },
      { "<leader>fF", Skybox.pick("files", { root = false }),                     desc = "Find Files (cwd)" },
      { "<leader>fg", "<cmd>FzfLua git_files<cr>",                                desc = "Find Files (git-files)" },
      { "<leader>fr", "<cmd>FzfLua oldfiles<cr>",                                 desc = "Recent" },
      { "<leader>fR", Skybox.pick("oldfiles", { cwd = vim.uv.cwd() }),            desc = "Recent (cwd)" },
      -- git
      { "<leader>gc", "<cmd>FzfLua git_commits<CR>",                              desc = "Commits" },
      { "<leader>gs", "<cmd>FzfLua git_status<CR>",                               desc = "Status" },
      -- search
      { '<leader>s"', "<cmd>FzfLua registers<cr>",                                desc = "Registers" },
      { "<leader>sa", "<cmd>FzfLua autocmds<cr>",                                 desc = "Auto Commands" },
      { "<leader>sb", "<cmd>FzfLua grep_curbuf<cr>",                              desc = "Buffer" },
      { "<leader>sc", "<cmd>FzfLua command_history<cr>",                          desc = "Command History" },
      { "<leader>sC", "<cmd>FzfLua commands<cr>",                                 desc = "Commands" },
      { "<leader>sd", "<cmd>FzfLua diagnostics_document<cr>",                     desc = "Document Diagnostics" },
      { "<leader>sD", "<cmd>FzfLua diagnostics_workspace<cr>",                    desc = "Workspace Diagnostics" },
      { "<leader>sg", Skybox.pick("live_grep"),                                   desc = "Grep (Root Dir)" },
      { "<leader>sG", Skybox.pick("live_grep", { root = false }),                 desc = "Grep (cwd)" },
      { "<leader>sh", "<cmd>FzfLua help_tags<cr>",                                desc = "Help Pages" },
      { "<leader>sH", "<cmd>FzfLua highlights<cr>",                               desc = "Search Highlight Groups" },
      { "<leader>sj", "<cmd>FzfLua jumps<cr>",                                    desc = "Jumplist" },
      { "<leader>sk", "<cmd>FzfLua keymaps<cr>",                                  desc = "Key Maps" },
      { "<leader>sl", "<cmd>FzfLua loclist<cr>",                                  desc = "Location List" },
      { "<leader>sM", "<cmd>FzfLua man_pages<cr>",                                desc = "Man Pages" },
      { "<leader>sm", "<cmd>FzfLua marks<cr>",                                    desc = "Jump to Mark" },
      { "<leader>sR", "<cmd>FzfLua resume<cr>",                                   desc = "Resume" },
      { "<leader>sq", "<cmd>FzfLua quickfix<cr>",                                 desc = "Quickfix List" },
      { "<leader>sq", "<cmd>FzfLua quickfix<cr>",                                 desc = "Quickfix List" },
      { "<leader>sw", Skybox.pick("grep_cword"),                                  desc = "Word (Root Dir)" },
      { "<leader>sW", Skybox.pick("grep_cword", { root = false }),                desc = "Word (cwd)" },
      { "<leader>sw", Skybox.pick("grep_visual"),                                 mode = "v",                      desc = "Selection (Root Dir)" },
      { "<leader>sW", Skybox.pick("grep_visual", { root = false }),               mode = "v",                      desc = "Selection (cwd)" },
    }
  },
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = {
      modes = { insert = true, command = true, terminal = false },
      -- skip autopair when next character is one of these
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      -- skip autopair when the cursor is inside these treesitter nodes
      skip_ts = { "string" },
      -- skip autopair when next character is closing pair
      -- and there are more closing pairs than opening pairs
      skip_unbalanced = true,
      -- better deal with markdown code blocks
      markdown = true,
    },
    config = function(_, opts)
      Snacks.toggle({
        name = "Mini Pairs",
        get = function()
          return not vim.g.minipairs_disable
        end,
        set = function(state)
          vim.g.minipairs_disable = not state
        end
      }):map("<leader>up")

      local pairs = require('mini.pairs')
      pairs.setup(opts)
      local open = pairs.open
      pairs.open = function(pair, neigh_pattern)
        if vim.fn.getcmdline() ~= "" then
          return open(pair, neigh_pattern)
        end
        local o, c = pair:sub(1, 1), pair:sub(2, 2)
        local line = vim.api.nvim_get_current_line()
        local cursor = vim.api.nvim_win_get_cursor(0)
        local next = line:sub(cursor[2] + 1, cursor[2] + 1)
        local before = line:sub(1, cursor[2])
        if opts.markdown and o == "`" and vim.bo.filetype == "markdown" and before:match("^%s*``") then
          return "`\n```" .. vim.api.nvim_replace_termcodes("<up>", true, true, true)
        end
        if opts.skip_next and next ~= "" and next:match(opts.skip_next) then
          return o
        end
        if opts.skip_ts and #opts.skip_ts > 0 then
          local ok, captures = pcall(vim.treesitter.get_captures_at_pos, 0, cursor[1] - 1, math.max(cursor[2] - 1, 0))
          for _, capture in ipairs(ok and captures or {}) do
            if vim.tbl_contains(opts.skip_ts, capture.capture) then
              return o
            end
          end
        end
        if opts.skip_unbalanced and next == c and c ~= o then
          local _, count_open = line:gsub(vim.pesc(pair:sub(1, 1)), "")
          local _, count_close = line:gsub(vim.pesc(pair:sub(2, 2)), "")
          if count_close > count_open then
            return o
          end
        end
        return open(pair, neigh_pattern)
      end
    end
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    cmd = { "TodoTrouble", "TodoFzfLua" },
    keys = {
      { "]t",         function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
      { "[t",         function() require("todo-comments").jump_prev() end, desc = "Previous Todo Comment" },
      { "<leader>ft", "<cmd>TodoFzfLua<CR>",                               desc = "Toggle TODO list" }
    },
    opts = {
      signs = false,
      gui_style = {
        fg = "ITALIC" -- NOTE: just incase comments aren't italic for the colorscheme.
      }
    }
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
      {
        "<c-w><space>",
        function()
          require("which-key").show({ keys = "<c-w>", loop = true })
        end,
        desc = "Window Hydra Mode (which-key)"
      }
    },
    opts = {
      delay = 500,
      preset = "helix",
      spec = {
        { "<leader>f",      group = "find" },
        { "<leader>l",      group = "lsp" },
        { "<leader>g",      group = "git" },
        { "<localleader>g", group = "go" },
        { "<leader>i",      group = "insert" },
        { "<leader>h",      group = "hunk" },
        { "<leader>s",      group = "search" },
        { "<leader>u",      group = "toggles" },
        { "<leader>e",      group = "edit" },
        { "<leader>t",      group = "test" },
        { "<leader>q",      group = "sessions" },
        { "<localleader>b", group = "buffer" },
        { "<localleader>d", group = "debug" },
        { "<localleader>h", group = "hunk" },
        { "<localleader>r", group = "repl" },
        { "<localleader>t", group = "tabs" },
        { "<localleader>s", group = "splits" },
        {
          "<c-w>",
          group = "windows",
          expand = function()
            return require('which-key.extras').expand.win()
          end
        }
      },
      icons = {
        mappings = false,
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        -- separator = "➜", -- symbol used between a key and it's label
        separator = "->", -- symbol used between a key and it's label
        group = "+",      -- symbol prepended to a group
      },
      layout = { align = "center" },
      triggers = {
        { "<auto>", mode = "nso" },
      },
      plugins = {
        marks = true,     -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        spelling = {
          enabled = true,   -- enabling this will show WhichKey when pressing z= to select spelling suggestions
          suggestions = 20, -- how many suggestions should be shown in the list?
        },
        presets = {
          operators = false,   -- adds help for operators like d, y, ... and registers them for motion / text object completion
          motions = false,     -- adds help for motions
          text_objects = true, -- help for text objects triggered after entering an operator
          windows = false,     -- default bindings on <c-w>
          nav = true,          -- misc bindings to work with windows
          z = true,            -- bindings for folds, spelling and others prefixed with z
          g = true,            -- bindings for prefixed with g
        },
      },
      replace = {
        -- override the label used to display some keys. It doesn't effect WK in any other way.
        -- For example:
        ["<space>"] = "SPC",
        ["<cr>"] = "RET",
        ["<tab>"] = "TAB",
      },
      win = { border = Skybox.ui.cur_border },
      show_help = true,
    },
    config = function(_, opts)
      local wk = require("which-key")
      vim.api.nvim_set_hl(0, "WhichKeyValue", { link = "NormalFloat" })
      vim.api.nvim_set_hl(0, "WhichKeyDesc", { link = "NormalFloat" })
      wk.setup(opts)
    end,
  },
  {
    "MagicDuck/grug-far.nvim",
    opts = { headerMaxWidth = 80 },
    cmd = "GrugFar",
    keys = {
      {
        "<leader>sr",
        function()
          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          grug.open({
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          })
        end,
        mode = { "n", "v" },
        desc = "Search and Replace",
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "UiEnter",
    config = function()
      require("gitsigns").setup({
        attach_to_untracked = false,
        preview_config = {
          border = Skybox.ui.cur_border,
          style = "minimal",
          relative = "cursor",
          row = 0,
          col = 1,
        },
        signs = {
          add = {
            -- hl = "GitSignsAdd",
            -- culhl = "GitSignsAddCursorLine",
            -- numhl = "GitSignsAddNum",
            text = Skybox.ui.git.icons.add,
          }, -- alts: ▕, ▎, ┃, │, ▌, ▎ 🮉
          change = {
            -- hl = "GitSignsChange",
            -- culhl = "GitSignsChangeCursorLine",
            -- numhl = "GitSignsChangeNum",
            text = Skybox.ui.git.icons.change,
          }, -- alts: ▎║▎
          delete = {
            -- hl = "GitSignsDelete",
            -- culhl = "GitSignsDeleteCursorLine",
            -- numhl = "GitSignsDeleteNum",
            text = Skybox.ui.git.icons.delete,
          }, -- alts: ┊▎▎
          topdelete = {
            -- hl = "GitSignsDelete",
            text = Skybox.ui.git.icons.topdelete,
          }, -- alts: ▌ ▄▀
          changedelete = {
            -- hl = "GitSignsChange",
            text = Skybox.ui.git.icons.changedelete,
          }, -- alts: ▌
          untracked = {
            -- hl = "GitSignsAdd",
            text = Skybox.ui.git.icons.untracked,
          }, -- alts: ┆ ▕
          signs_staged = {
            change = { text = "┋" },
            delete = { text = "🢒" },
          },
        },
        signcolumn = true,
        update_debounce = 500,
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, desc)
            vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
          end

          -- stylua: ignore start
          map("n", "]h", function()
            if vim.wo.diff then
              vim.cmd.normal({ "]c", bang = true })
            else
              gs.nav_hunk("next")
            end
          end, "Next Hunk")
          map("n", "[h", function()
            if vim.wo.diff then
              vim.cmd.normal({ "[c", bang = true })
            else
              gs.nav_hunk("prev")
            end
          end, "Prev Hunk")
          map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
          map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")
          map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")
          map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
          map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
          map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
          map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
          map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
          map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
          map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
          map("n", "<leader>ghB", function() gs.blame() end, "Blame Buffer")
          map("n", "<leader>ghd", gs.diffthis, "Diff This")
          map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
        end,
      })
      Snacks.toggle({
        name = "Git Signs",
        get = function()
          return require("gitsigns.config").config.signcolumn
        end,
        set = function(state)
          require("gitsigns").toggle_signs(state)
        end,
      }):map("<leader>uG")
    end,
  },
}
