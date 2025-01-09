local M = { 'comfysage/evergarden' }

M.lazy = false
M.priority = 1000

M.opts = {
    variant = 'hard',
    transparent_background = false,
}

M.setup = function(_, opts)
    require('evergarden').setup(opts)
    vim.opt.background = 'dark'
    vim.cmd.colorscheme('evergarden')
end

return M
