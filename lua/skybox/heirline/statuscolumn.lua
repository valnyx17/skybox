local utils = require("skybox.util.heirline")
local gitsigns_avail, gitsigns = pcall(require, "gitsigns")
local function get_num_wraps()
    local winid = vim.api.nvim_get_current_win()
    local lnum = vim.v.lnum
    return vim.api.nvim_win_text_height(winid, {
        start_row = lnum - 1,
        end_row = lnum - 1,
    })["all"]
end
local function swap(start_val, end_val)
    if start_val > end_val then
        local swap_val = start_val
        start_val = end_val
        end_val = swap_val
    end

    return start_val, end_val
end
local function get_buf_width()
    local win_id = vim.api.nvim_get_current_win()
    local win_info = vim.fn.getwininfo(win_id)[1]
    return win_info["width"] - win_info["textoff"]
end
local spacer = { provider = " " }
local align = { provider = "%=" }

local git_ns = vim.api.nvim_create_namespace("gitsigns_signs_")

local function get_signs(bufnr, lnum)
    local signs = {}

    local extmarks = vim.api.nvim_buf_get_extmarks(
        0,
        -1,
        { lnum - 1, 0 },
        { lnum - 1, -1 },
        { details = true, type = "sign" }
    )

    for _, extmark in pairs(extmarks) do
        -- Exclude gitsigns
        if extmark[4].ns_id ~= git_ns then
            signs[#signs + 1] = {
                name = extmark[4].sign_hl_group or "",
                text = extmark[4].sign_text,
                sign_hl_group = extmark[4].sign_hl_group,
                priority = extmark[4].priority,
            }
        end
    end

    table.sort(signs, function(a, b)
        return (a.priority or 0) > (b.priority or 0)
    end)

    return signs
end

local Line = {
    provider = function()
        local virtnum = vim.v.virtnum
        local lnum = vim.v.lnum

        if virtnum > 0 then
            local num_wraps = get_num_wraps()

            return virtnum == num_wraps - 1 and "└" or "├"
        end

        if virtnum < 0 then
            return "-"
        end

        local relnum = vim.v.relnum

        if relnum == 0 then
            return lnum
        end
        return relnum
    end,
    hl = function()
        local mode = vim.fn.mode()
        local normalized_mode = vim.fn.strtrans(mode):lower():gsub("%W", "")
        local lnum = vim.v.lnum

        local e_row = vim.fn.line(".")
        -- if the line is wrapped and we are not in visual mode
        if normalized_mode ~= "v" then
            return e_row == lnum and "CursorLineNr" or "LineNr"
        end

        local s_row = vim.fn.line("v")
        local normed_s_row, normed_e_row = swap(s_row, e_row)
        -- if the line number is outside our visual selection
        if lnum < normed_s_row or lnum > normed_e_row then
            return "LineNr"
        end

        -- if the line number is visually selected and not wrapped
        local virtnum = vim.v.virtnum
        local num_wraps = get_num_wraps()
        if virtnum == 0 and num_wraps == 1 then
            return "CursorLineNr"
        end

        -- if the line is visually selected and wrapped, only highlighht selected screen lines
        local buf_width = get_buf_width()
        local vis_start_wrap = math.floor((vim.fn.virtcol("v") - 1) / buf_width)
        local vis_end_wrap = math.floor((vim.fn.virtcol(".") - 1) / buf_width)
        local normed_vis_start_wrap, normed_vis_end_wrap = swap(vis_start_wrap, vis_end_wrap)

        if normed_s_row < lnum and (virtnum <= normed_vis_end_wrap or normed_e_row > lnum) then
            return "CursorLineNr"
        end

        if
            normed_s_row == lnum
                and (normed_e_row == lnum and virtnum >= normed_vis_start_wrap and virtnum <= normed_vis_end_wrap)
            or (normed_e_row > lnum and virtnum >= vis_end_wrap)
        then
            return "CursorLineNr"
        end

        return "LineNr"
    end,
    on_click = {
        name = "line_number_click",
        callback = function(self, ...)
            if self.handlers.line_number then
                self.handlers.line_number(self.click_args(self, ...))
            end
        end,
    },
}

local Signs = {
    init = function(self)
        local signs = get_signs(self.bufnr, vim.v.lnum)
        self.sign = signs[1]
    end,
    provider = function(self)
        return self.sign and self.sign.text or "  "
    end,
    hl = function(self)
        return self.sign and self.sign.sign_hl_group
    end,
    on_click = {
        name = "sc_sign_click",
        update = true,
        callback = function(self, ...)
            local line = self.click_args(self, ...).mousepos.line
            local sign = get_signs(self.bufnr, line)[1]
            if sign then
                self:resolve(sign.name)
            end
        end,
    },
}

local Folds = {
    init = function(self)
        local lnum = vim.v.lnum
        self.can_fold = vim.fn.foldlevel(lnum) > vim.fn.foldlevel(lnum - 1)
        self.foldclosed = vim.fn.foldclosed(lnum) == -1
    end,
    {
        provider = function(self)
            if vim.v.virtnum ~= 0 then
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
            return vim.v.virtnum == 0 and self.can_fold
        end,
    },
    {
        condition = function(self)
            return not self.can_fold
        end,
        spacer,
    },
    hl = function(self)
        if self.can_fold and vim.v.relnum == 0 then
            return "CursorLineNr"
        end
    end,
    on_click = {
        name = "fold_click",
        callback = function(self, ...)
            if self.handlers.fold then
                self.handlers.fold(self.click_args(self, ...))
            end
        end,
    },
}

-- local GitSigns = {
--     init = function(self)
--         local signs = vim.fn.sign_getplaced(vim.api.nvim_get_current_buf(), {
--             group = "gitsigns_vimfn_signs_",
--             id = vim.v.lnum,
--             lnum = vim.v.lnum,
--         })
--         if #signs == 0 or signs[1].signs == nil or #signs[1].signs == 0 or signs[1].signs[1].name == nil then
--             self.sign = nil
--         else
--             self.sign = signs[1].signs[1]
--         end
--         self.has_sign = self.sign ~= nil
--     end,
--     provider = " ▏",
--     hl = function(self)
--         if self.has_sign then return self.sign.name end
--         local mode = vim.fn.mode()
--         local normalized_mode = vim.fn.strtrans(mode):lower():gsub("%W", "")
--         local lnum = vim.v.lnum
--         local relnum = vim.v.relnum
--         local hl = {}
--         local active = {
--             fg = utils.colors.palette.dragonRed
--         }
--
--         if relnum == 0 then hl = active end
--         if normalized_mode == 'v' then
--             local pos_list = vim.fn.getregionpos(
--                 vim.fn.getpos('v'),
--                 vim.fn.getpos('.'),
--                 { type = mode, eol = true }
--             )
--             local s_row, e_row = pos_list[1][1][2], pos_list[#pos_list][2][2]
--
--             if lnum >= s_row and lnum <= e_row then
--                 hl = active
--             end
--         end
--
--         return hl or "LineNr"
--     end,
--     on_click = {
--         name = "gitsigns_click",
--         callback = function(self, ...)
--             if self.handlers.git_signs then self.handlers.git_signs(self.click_args(self, ...)) end
--         end,
--     },
-- }

local GitSigns = {
    {
        condition = function()
            return utils.conditions.is_git_repo()
        end,
        init = function(self)
            local extmark = vim.api.nvim_buf_get_extmarks(
                0,
                git_ns,
                { vim.v.lnum - 1, 0 },
                { vim.v.lnum - 1, -1 },
                { limit = 1, details = true }
            )[1]

            self.sign = extmark and extmark[4]["sign_hl_group"]
        end,
        {
            provider = "│",
            hl = function(self)
                return self.sign or { fg = "bg" }
            end,
            on_click = {
                name = "sc_gitsigns_click",
                callback = function(self, ...)
                    self.handlers.GitSigns(self.click_args(self, ...))
                end,
            },
        },
    },
    {
        condition = function()
            return not utils.conditions.is_git_repo()
        end,
        spacer,
    },
}

return {
    static = {
        click_args = function(self, minwid, clicks, button, mods)
            local args = {
                minwid = minwid,
                clicks = clicks,
                button = button,
                mods = mods,
                mousepos = vim.fn.getmousepos(),
            }
            local sign = vim.fn.screenstring(args.mousepos.screenrow, args.mousepos.screencol)
            if sign == " " then
                sign = vim.fn.screenstring(args.mousepos.screenrow, args.mousepos.screencol - 1)
            end
            args.sign = self.signs[sign]
            vim.api.nvim_set_current_win(args.mousepos.winid)
            vim.api.nvim_win_set_cursor(0, { args.mousepos.line, 0 })

            return args
        end,
        resolve = function(self, name)
            for pattern, callback in pairs(self.handlers.Signs) do
                if name:match(pattern) then
                    return vim.defer_fn(callback, 100)
                end
            end
        end,
        handlers = {
            line_number = function(args)
                local dap_avail, dap = pcall(require, "dap")
                if dap_avail then
                    vim.schedule(dap.toggle_breakpoint)
                end
            end,
            Signs = {
                ["Neotest.*"] = function(self, args)
                    require("neotest").run.run()
                end,
                ["Debug.*"] = function(self, args)
                    require("dap").continue()
                end,
                ["Diagnostic.*"] = function(self, args)
                    vim.diagnostic.open_float()
                end,
                ["LspLightBulb"] = function(self, args)
                    vim.lsp.buf.code_action()
                end,
            },
            -- diagnostics = function(args) vim.schedule(vim.diagnostic.open_float) end,
            git_signs = function(args)
                if gitsigns_avail then
                    vim.schedule(gitsigns.preview_hunk)
                end
            end,
            fold = function(args)
                local lnum = args.mousepos.line
                if vim.fn.foldlevel(lnum) <= vim.fn.foldlevel(lnum - 1) then
                    return
                end
                vim.cmd.execute("'" .. lnum .. "fold" .. (vim.fn.foldclosed(lnum) == -1 and "close" or "open") .. "'")
            end,
        },
    },
    init = function(self)
        self.signs = {}
        for _, sign in ipairs(vim.fn.sign_getdefined()) do
            if sign.text then
                self.signs[sign.text:gsub("%s", "")] = sign
            end
        end
    end,
    Signs,
    align,
    Line,
    spacer,
    Folds,
    GitSigns,
}
