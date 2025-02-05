return {
  "rebelot/heirline.nvim",
  event = "UiEnter",
  config = function()
    require('heirline').setup({
      -- statusline = require('viv.statusline'),
      statuscolumn = require('viv.statuscolumn')
    })
  end
}
