return {
  {
    "rachartier/tiny-glimmer.nvim",
    event = "UiEnter",
    opts = {
      overwite = {
        auto_map = false,
      },
      animations = {
        fade = {
          from_color = "#e67e80",
          to_color = "Normal"
        }
      }
    }
  },
  {
    "comfysage/evergarden",
    lazy = false,
    priority = 9999,
    opts = {
      variant = 'hard',
      transparent_background = false,
    },
  },
  {
    "rebelot/heirline.nvim",
    event = "UiEnter",
    config = function()
      require('heirline').setup({
        statusline = require('skybox.heirline.statusline'),
        statuscolumn = require('skybox.heirline.statuscolumn')
      })
    end
  }
}
