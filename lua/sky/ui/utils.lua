local M = {}

M.conditions = require("heirline.conditions")
M.lsp_attached = function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if next(clients) == nil then return false end
    if #clients > 1 then return true end
    for _, client in pairs(clients) do
        if client.name == "copilot" then
            return false
        else
            return true
        end
    end
end
M.fn = require("heirline.utils")

-- M.colors = require("kanagawa.colors").setup()
M.colors = require('evergarden').colors()

return M
