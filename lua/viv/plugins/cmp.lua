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
        { path = "snacks.nvim", words = { "Snacks" } },
      }
    }
  },
  {
    "saghen/blink.cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = (function()
          if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
            return
          end
          return "make install_jsregexp"
        end)(),
        dependencies = {
          {
            "rafamadriz/friendly-snippets",
          },
        },
        opts = {
          history = true,
          delete_check_events = "TextChanged",
        },
        config = function(_, opts)
          require('luasnip').setup(opts)
          require('luasnip.loaders.from_vscode').lazy_load()
          require('luasnip.loaders.from_lua').load({
            paths = {
              vim.fn.stdpath("config") .. "/snippets",
            }
          })
        end
      },
    },
    version = "*",
    build = "nix run .#build-plugin",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      sources = {
        default = { "lsp", "lazydev", "path", "snippets", "buffer" },
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
        },
      },
      snippets = {
        -- preset = "luasnip",
        expand = function(snippet)
          require('luasnip').lsp_expand(snippet)
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
          Copilot = viv.ui.icons.kind.Text
        }, viv.ui.icons.kind)
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
          },
        },
      },
    },
  },
}
