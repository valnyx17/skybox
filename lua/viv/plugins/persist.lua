return {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
    -- stylua: ignore
    keys = {
        { "<localleader>pr", function() require("persistence").load() end,                desc = "Restore Session" },
        { "<localleader>ps", function() require("persistence").select() end,              desc = "Select Session" },
        { "<localleader>pl", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
        { "<localleader>pd", function() require("persistence").stop() end,                desc = "Don't Save Current Session" },
    },
},
