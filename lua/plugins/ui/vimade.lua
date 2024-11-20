return {
    "tadaa/vimade",
    event = "VeryLazy",
    config = function()
        local Minimalist = require('vimade.recipe.minimalist').Minimalist
        require('vimade').setup(Minimalist { animate = true })
    end
}
