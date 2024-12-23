local M = {}

M.check = function()
    vim.health.start("sky report")
    vim.health.ok("no health checks to add yet!")
end

return M
