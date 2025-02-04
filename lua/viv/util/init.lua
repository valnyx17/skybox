local LazyUtil = require("lazy.core.util")

---@class viv.util
local M = setmetatable({}, {
    __index = function(t, k)
        if LazyUtil[k] then
            return LazyUtil[k]
        end

        ---@diagnostic disable-next-line: no-unknown
        t[k] = require('viv.util.' .. k)
        return t[k]
    end
})
