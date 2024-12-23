local M = { "rebelot/heirline.nvim" }

M.event = "UiEnter"

M.config = function()
    require("heirline").setup({
        statusline = require("sky.ui.statusline"),
        statuscolumn = require("sky.ui.statuscolumn"),
        -- winbar = require('sky.ui.winbar'),
        -- tabline = require('sky.ui.tabline'),
    })
end

return M
