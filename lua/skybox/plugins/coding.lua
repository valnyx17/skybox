local ui = require('skybox.util.ui')
local winhighlight = table.concat({
  "Normal:BlinkCmpMenu",
  -- "Normal:NormalFloat",
  "FloatBorder:BlinkCmpMenuBorder",
  "CursorLine:PmenuMatchSel",
  "Search:None",
}, ",")

return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    dependencies = {
      "Bilal2453/luvit-meta",
    },
    opts = {
      library = {
        "lazy.nvim",
        { path = "luvit-meta/library", words = { "vim%.uv" } },
        {
          path = "/run/current-system/sw/share/awesome/lib",
          mods = { "awful", "beautiful", "gears", "menubar", "naughty", "wibox", "awesome" },
        },
        { path = "snacks.nvim",        words = { "Snacks" } },
      },
    },
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod",                     lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
  {
    "saghen/blink.cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
            return
          end
          return "make install_jsregexp"
        end)(),
        dependencies = {
          {
            "rafamadriz/friendly-snippets",
            config = function()
              require("luasnip.loaders.from_vscode").lazy_load()
            end,
          },
        },
        opts = {
          history = true,
          delete_check_events = "TextChanged",
        },
        config = function(_, opts)
          require("luasnip").setup(opts)
          require("luasnip.loaders.from_lua").load({
            paths = {
              vim.fn.stdpath("config") .. "/snippets",
            },
          })
        end,
      },
    },
    version = "*",
    build = "nix run .#build-plugin",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      sources = {
        default = { "lsp", "lazydev", "path", "snippets", "buffer", "dadbod" },
        cmdline = function()
          local type = vim.fn.getcmdtype()

          if type == "/" or type == "?" then
            return { "buffer" }
          end
          if type == ":" then
            return { "cmdline" }
          end
          return {}
        end,
        providers = {
          lazydev = {
            name = "LazyDev",
            enabled = true,
            module = "lazydev.integrations.blink",
            score_offset = 11,
          },
          lsp = {
            name = "lsp",
            enabled = true,
            module = "blink.cmp.sources.lsp",
            fallbacks = {},    -- do not use `buffer` as a fallback
            -- kind = "LSP",
            score_offset = 10, -- higher number = higher priority
          },
          buffer = {
            max_items = 4,
            min_keyword_length = 4,
            score_offset = 2
          },
          snippets = {
            name = "snippets",
            enabled = true,
            module = "blink.cmp.sources.snippets",
            score_offset = 9,
            min_keyword_length = 1,
          },
          dadbod = {
            name = "dadbod",
            module = "vim_dadbod_completion.blink",
            score_offset = 9,
          },
        },
      },
      snippets = {
        preset = "luasnip",
        expand = function(snippet)
          require("luasnip").lsp_expand(snippet)
        end,
        active = function(filter)
          if filter and filter.direction then
            return require("luasnip").jumpable(filter.direction)
          end
          return require("luasnip").in_snippet()
        end,
        jump = function(direction)
          require("luasnip").jump(direction)
        end,
      },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "normal",
        kind_icons = vim.tbl_extend("keep", {
          Color = "██",
          Copilot = ui.icons.kind.Text
        }, ui.icons.kind)
      },
      keymap = {
        ["<M-j>"] = {
          function()
            if require("luasnip").choice_active() then
              require("luasnip").change_choice(1)
              return true
            end
          end,
          "select_next",
          "fallback",
        },
        ["<M-k>"] = {
          function()
            if require("luasnip").choice_active() then
              require("luasnip").change_choice(-1)
              return true
            end
          end,
          "select_prev",
          "fallback",
        },
        ["<M-u>"] = { "scroll_documentation_up", "fallback" },
        ["<M-d>"] = { "scroll_documentation_down", "fallback" },
        ["<M-i>"] = { "select_and_accept" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<M-c>"] = { "show", "show_documentation", "hide_documentation", "fallback" },
        ["<M-l>"] = { "snippet_forward", "fallback" },
        ["<M-h>"] = { "snippet_backward", "fallback" },
        ["<A-1>"] = {
          function(cmp)
            cmp.accept({ index = 1 })
          end,
        },
        ["<A-2>"] = {
          function(cmp)
            cmp.accept({ index = 2 })
          end,
        },
        ["<A-3>"] = {
          function(cmp)
            cmp.accept({ index = 3 })
          end,
        },
        ["<A-4>"] = {
          function(cmp)
            cmp.accept({ index = 4 })
          end,
        },
        ["<A-5>"] = {
          function(cmp)
            cmp.accept({ index = 5 })
          end,
        },
        ["<A-6>"] = {
          function(cmp)
            cmp.accept({ index = 6 })
          end,
        },
        ["<A-7>"] = {
          function(cmp)
            cmp.accept({ index = 7 })
          end,
        },
        ["<A-8>"] = {
          function(cmp)
            cmp.accept({ index = 8 })
          end,
        },
        ["<A-9>"] = {
          function(cmp)
            cmp.accept({ index = 9 })
          end,
        },
        ["<A-0>"] = {
          function(cmp)
            cmp.accept({ index = 10 })
          end,
        },
      },
      signature = { enabled = true },
      completion = {
        menu = {
          winhighlight = winhighlight,
          min_width = 10,
          -- winblend = 25,
          scrollbar = false,
          draw = {
            align_to = "label",
            padding = 1,
            gap = 1,
            treesitter = { "lsp" },
            components = {
              label = {
                width = { min = 20, fill = false }
              },
              kind = {
                width = { fill = false },
                text = function(ctx)
                  return string.lower(ctx.kind)
                end
              },
            },
            columns = {
              { "kind_icon", gap = 1 },
              { "label" },
              -- { "kind_icon",  "kind", gap = 1 },
              { "kind" },
            },
          },
        },
        keyword = {
          range = "full",
        },
        list = {
          selection = {
            preselect = true,
            auto_insert = function(ctx) return ctx.mode == 'cmdline' end
          }
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 0,
          window = {
            -- winblend = 25,
            winhighlight = winhighlight,
          },
        },
      },
    },
  },
  {
    "echasnovski/mini.ai",
    event = "LazyFile",
    opts = function()
      local ai = require('mini.ai')
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({ -- code block
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),       -- class
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },           -- tags
          d = { "%f[%d]%d+" },                                                          -- digits
          e = {                                                                         -- Word with case
            { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
            "^().*()$",
          },
          g = Skybox.mini.ai_buffer,                                 -- buffer
          u = ai.gen_spec.function_call(),                           -- u for "Usage"
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
        },
      }
    end,
    config = function(_, opts)
      require('mini.ai').setup(opts)

      Skybox.on_load("which-key.nvim", function()
        vim.schedule(function()
          Skybox.mini.ai_whichkey(opts)
        end)
      end)
    end
  },
  {
    "echasnovski/mini.move",
    event = "LazyFile",
    opts = {},
  },
  {
    "echasnovski/mini.jump",
    event = "LazyFile",
    opts = {
      mappings = {
        forward = "f",
        backward = "F",
        forward_till = "t",
        backward_till = "T",
        repeat_jump = ";",
      },
      delay = {
        highlight = 100,
        idle_stop = 10000000000000,
      },
    },
  },
  {
    "echasnovski/mini.jump2d",
    event = "LazyFile",
    opts = {},
  },
  {
    "echasnovski/mini.comment",
    event = "LazyFile",
    opts = {},
  },
  {
    "echasnovski/mini.surround",
    event = "LazyFile",
    opts = {
      mappings = {
        add = "ys",             -- Add surrounding in Normal and Visual modes
        delete = "ds",          -- Delete surrounding
        find = "gsf",           -- Find surrounding (to the right)
        find_left = "gsF",      -- Find surrounding (to the left)
        highlight = "gsh",      -- Highlight surrounding
        replace = "cs",         -- Replace surrounding
        update_n_lines = "gsn", -- Update `n_lines`

        suffix_last = "l",      -- Suffix to search with "prev" method
        suffix_next = "n",      -- Suffix to search with "next" method
      },
    },
  },
  {
    "echasnovski/mini.bracketed",
    event = "LazyFile",
    opts = {},
  }
}
