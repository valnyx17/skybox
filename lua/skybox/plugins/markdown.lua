return {
  {
    "ray-x/yamlmatter.nvim",
    cond = false,
    ft = { "markdown" },
    config = function()
      require("yamlmatter").setup({
        key_value_padding = 4, -- Default padding between key and value
        icon_mappings = {
          -- Default icon mappings
          title = "",
          author = "",
          date = "",
          id = "",
          tags = "",
          category = "",
          type = "",
          default = "󰦨",
        },
        highlight_groups = {
          -- icon = 'YamlFrontmatterIcon',
          -- key = 'YamlFrontmatterKey',
          -- value = 'YamlFrontmatterValue',
          icon = "Identifier",
          key = "Function",
          value = "Type",
        },
      })
    end,
  },
  {
    "OXY2DEV/markview.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local presets = require("markview.presets")

      require('markview').setup({
        markdown = {
          headings = {
            enable = true,
            shift_width = 0,

            setext_1 = {
              style = "github",

              icon = "   ",
              hl = "MarkviewHeading1",
              underline = "━"
            },
            setext_2 = {
              style = "github",

              icon = "   ",
              hl = "MarkviewHeading2",
              underline = "─"
            },

            heading_1 = {
              style = "label",

              padding_left = " ",
              padding_right = " ",

              hl = "MarkviewHeading1"
            },
            heading_2 = {
              style = "label",

              padding_left = " ",
              padding_right = " ",

              hl = "MarkviewHeading2"
            },
            heading_3 = {
              style = "label",

              padding_left = " ",
              padding_right = " ",

              hl = "MarkviewHeading3"
            },
            heading_4 = {
              style = "label",

              padding_left = " ",
              padding_right = " ",

              hl = "MarkviewHeading4"
            },
            heading_5 = {
              style = "label",

              padding_left = " ",
              padding_right = " ",

              hl = "MarkviewHeading5"
            },
            heading_6 = {
              style = "label",

              padding_left = " ",
              padding_right = " ",

              hl = "MarkviewHeading6"
            },
          }
        }
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "MarkviewAttach",
        group = vim.api.nvim_create_augroup("f", { clear = true }),
        callback = function(args)
          print("buf: " .. vim.inspect(args.data.buffer))
          print("windows: " .. vim.inspect(args.data.windows))
        end
      })
    end
  },
  {
    "epwalsh/obsidian.nvim",
    event = {
      "BufReadPre " .. vim.fn.expand("~") .. "/zet/*.md",
      "BufNewFile " .. vim.fn.expand("~") .. "/zet/*.md",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      workspaces = {
        {
          name = "Universal",
          path = "~/zet",
        },
      },
      templates = {
        folder = "templates",
        date_format = "%Y-%m-%d-%a",
        time_format = "%H:%M",
      },
      ui = { enable = false },
      node_id_func = function(title)
        local suffix = ""
        if title ~= nil then
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return tostring(os.time()) .. "-" .. suffix
      end
    },
    config = function(_, opts)
      require("obsidian").setup(opts)
      vim.keymap.set("n", "<localleader>on", "<cmd>ObsidianNew<CR>")
    end
  }
}
