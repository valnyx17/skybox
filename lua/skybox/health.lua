local M = {}
local health = vim.health
local fn = vim.fn

local function check_executable(executable)
  if fn.executable(executable) == 1 then
    health.ok(executable .. " is found.")
  else
    local advice = {
      'Install ' .. executable .. '.'
    }
    health.error(executable .. ' is not found.', advice)
  end
end

M.check = function()
  health.start("skybox report")
  check_executable("fzf")
  check_executable("rg")
  check_executable("fd")
end

return M
