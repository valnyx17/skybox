return {
    "gbprod/substitute.nvim",
    event = "BufEnter",
    opts = {},
    config = function(_, opts)
        require("substitute").setup(opts)
        local map = require('sky.keymaps').set

        map("n", "s", require('substitute').operator, { noremap = true })
        map("n", "ss", require('substitute').line, { noremap = true })
        map("n", "S", require('substitute').eol, { noremap = true })
        map("x", "s", require('substitute').visual, { noremap = true })
    end
}
