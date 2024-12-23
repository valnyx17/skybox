local M = {}

---@enum Prefix
M.PREFIXES = {
    auto = "autocmds",
    misc = "misc",
    nogroup = "nogroup",
}

local function get_longest_prefix_length()
    local maxlen = 0
    for _, prefix in pairs(M.PREFIXES) do
        maxlen = math.max(#prefix, maxlen)
    end
    return maxlen
end

local maxlen = get_longest_prefix_length()

---Applies prefix to given description
---@param prefix Prefix | nil
---@param description string | nil
function M.prefix_description(prefix, description)
    if description == nil then
        description = "nil"
    end
    if prefix == nil then
        return M.PREFIXES.nogroup .. string.rep(" ", maxlen - #M.PREFIXES.nogroup) .. " | " .. description
    end
    return prefix .. string.rep(" ", maxlen - #prefix) .. " | " .. description
end

---Wraps a mapping function with a function that calls prefix_description
---@param func fun(map: table)
---@return fun(map: table)
function M.prefixifier(func)
    return function(map)
        for _, entry in ipairs(map) do
            entry.description = M.prefix_description(entry.prefix, entry.description)
        end
        func(map)
    end
end

return M
