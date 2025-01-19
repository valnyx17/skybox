local util = require('skybox.util.ui')
return {
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    -- icon support
    dependencies = { "echasnovski/mini.icons" },
    opts = {
      winopts = {
        border = util.borders.empty,
        preview = {
          border = util.borders.empty,
        },
      },
      fzf_colors = {
        true
      },
    },
    keys = {
      { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "[f]ind [f]iles" },
      { "<leader>fg", "<cmd>FzfLua live_grep<cr>", desc = "multi-[f]ile [g]rep" },
      { "<leader>fh", "<cmd>FzfLua helptags<cr>", desc = "[f]ind [h]elp" },
      { "<leader>,", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<CR>", desc = "switch buffer" },
      { "<leader>fb", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<CR>", desc = "switch buffer" },
      { "<leader>fg", "<cmd>FzfLua git_files<CR>", desc = "[g]it [f]iles" },
      { "<leader>fr", "<cmd>FzfLua oldfiles<CR>", desc = "[r]ecent [f]iles" },
    }
  },
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = {
      modes = { insert = true, command = true, terminal = false },
      -- skip autopair when next character is one of these
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
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
      { "<leader>ft", "<cmd>TodoFzfLua<CR>", { desc = "Toggle TODO list" } }
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
        { "<leader>f", group = "find" },
        { "<leader>l", group = "lsp" },
        { "<leader>g", group = "git" },
        { "<localleader>g", group = "go" },
        { "<leader>i", group = "insert" },
        { "<leader>h", group = "hunk" },
        { "<leader>b", group = "buffer" },
        { "<leader>s", group = "splits" },
        { "<leader>u", group = "toggles" },
        { "<leader>t", group = "tabs" },
        { "<leader>e", group = "edit" },
        { "<localleader>d", group = "debug" },
        { "<localleader>h", group = "hunk" },
        { "<localleader>r", group = "repl" },
        { "<localleader>t", group = "test" },
        { "<localleader>s", group = "sessions" },
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
        group = "+", -- symbol prepended to a group
      },
      layout = { align = "center" },
      triggers = {
        { "<auto>", mode = "nso" },
      },
      plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        spelling = {
          enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
          suggestions = 20, -- how many suggestions should be shown in the list?
        },
        presets = {
          operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
          motions = false, -- adds help for motions
          text_objects = true, -- help for text objects triggered after entering an operator
          windows = false, -- default bindings on <c-w>
          nav = true, -- misc bindings to work with windows
          z = true, -- bindings for folds, spelling and others prefixed with z
          g = true, -- bindings for prefixed with g
        },
      },
      replace = {
        -- override the label used to display some keys. It doesn't effect WK in any other way.
        -- For example:
        ["<space>"] = "SPC",
        ["<cr>"] = "RET",
        ["<tab>"] = "TAB",
      },
      win = { border = require("skybox.util.ui").cur_border },
      show_help = true,
    },
    config = function(_, opts)
      local wk = require("which-key")
      vim.api.nvim_set_hl(0, "WhichKeyValue", { link = "NormalFloat" })
      vim.api.nvim_set_hl(0, "WhichKeyDesc", { link = "NormalFloat" })
      wk.setup(opts)
    end,
  }
}
