local gsigns_ok, gitsigns = pcall(require, "gitsigns")
local mdiff_ok, mdiff = pcall(require, 'mini.diff')
local api = vim.api
local v = vim.v

local LineNr = {
  provider = function()
    if v.virtnum > 0 then
      local num_wraps = viv.heirline.get_num_wraps()
      return v.virtnum == num_wraps -1 and "└" or "├"
    elseif v.virtnum < 0 then
      return "-"
    end

    if v.relnum == 0 then
      return v.lnum
    end
    return v.relnum
  end,
  hl = function()
    local mode = vim.fn.mode()
    local normalized_mode = vim.fn.strtrans(mode):lower():gsub("%W", "")

    local e_row = vim.fn.line(".")
    -- if the line is wrapped and we are not in visual mode
    if normalized_mode ~= "v" then
      return e_row == v.lnum and "CursorLineNr" or "LineNr"
    end

    local s_row = vim.fn.line("v")
    local normed_s_row, normed_e_row = viv.heirline.swap(s_row, e_row)
    -- if the line number is outside our visual selection
    if v.lnum < normed_s_row or v.lnum > normed_e_row then
      return "LineNr"
    end

    -- if the line number is visually selected and not wrapped
    local num_wraps = viv.heirline.get_num_wraps()
    if v.virtnum == 0 and num_wraps == 1 then
      return "CursorLineNr"
    end

    -- if the line is visually selected and wrapped, only highlighht selected screen lines
    local buf_width = viv.heirline.get_buf_width()
    local vis_start_wrap = math.floor((vim.fn.virtcol("v") - 1) / buf_width)
    local vis_end_wrap = math.floor((vim.fn.virtcol(".") - 1) / buf_width)
    local normed_vis_start_wrap, normed_vis_end_wrap = viv.heirline.swap(vis_start_wrap, vis_end_wrap)

    if normed_s_row < v.lnum and (v.virtnum <= normed_vis_end_wrap or normed_e_row > v.lnum) then
      return "CursorLineNr"
    end

    if
        normed_s_row == v.lnum
        and (normed_e_row == v.lnum and v.virtnum >= normed_vis_start_wrap and v.virtnum <= normed_vis_end_wrap)
        or (normed_e_row > v.lnum and v.virtnum >= vis_end_wrap)
    then
      return "CursorLineNr"
    end

    return "LineNr"
  end
}

local Signs = {
  init = function(self)
    local signs = viv.heirline.get_signs(self.bufnr, v.lnum)
    self.sign = signs[1]
  end,
  provider = function(self)
    return self.sign and self.sign.text or "  "
  end,
  hl = function(self)
    return self.sign and self.sign.sign_hl_group
  end
}

local Folds = {
  init = function(self)
    self.can_fold = vim.fn.foldlevel(v.lnum) > vim.fn.foldlevel(v.lnum - 1)
    self.foldclosed = vim.fn.foldclosed(v.lnum) == -1
  end,
  {
    provider = function(self)
      if v.virtnum ~= 0 then
        return ""
      end
      local icon = " "
      if self.can_fold then
        if self.foldclosed then
          icon = ""
        else
          icon = ""
        end
      end
      return icon
    end,
    condition = function(self)
      return v.virtnum == 0 and self.can_fold
    end,
  },
  {
    condition = function(self) return not self.can_fold end,
    viv.heirline.Spacer,
  },
  hl = function(self)
    if self.can_fold and v.relnum == 0 then
      return "CursorLineNr"
    end
  end
}

local Git_Signs = {
  {
    condition = function()
      return viv.heirline.conditions.is_git_repo()
    end,
    init = function(self)
      if gsigns_ok then
        local extmark = api.nvim_buf_get_extmarks(
          0,
          viv.heirline.gsign_ns,
          { v.lnum - 1, 0 },
          { v.lnum - 1, -1 },
          { limit = 1, details = true }
        )[1]
      elseif mdiff_ok then
        local extmark = api.nvim_buf_get_extmarks(
          0,
          viv.heirline.mdiff_ns,
          { v.lnum - 1, 0 },
          { v.lnum - 1, -1 },
          { limit = 1, details = true }
        )[1]
      end

      self.sign = extmark and extmark[4]["sign_hl_group"]
    end,
    {
      provider = "│",
      hl = function(self)
        return self.sign or { fg = "bg" }
      end
    }
  },
  {
    condition = function()
      return not viv.heirline.conditions.is_git_repo()
    end,
    viv.heirline.Spacer
  },
}

return {
  init = function(self)
    self.signs = {}
    for _, sign in ipairs(vim.fn.sign_getdefined()) do
      if sign.text then
        self.signs[sign.text:gsub("%s", "")] = sign
      end
    end
  end,
  Signs,
  viv.heirline.Aligner,
  LineNr,
  viv.heirline.Spacer,
  Folds,
  Git_Signs
}
