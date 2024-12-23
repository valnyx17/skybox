local utils = require("sky.ui.utils")

local Mode = {
    init = function(self)
        self.mode = vim.fn.mode(1) -- :h mode()
    end,
    static = {
        mode_names = { -- change the strings if you like it vvvvverbose!
            n = "N",
            no = "N?",
            nov = "N?",
            noV = "N?",
            ["no\22"] = "N?",
            niI = "Ni",
            niR = "Nr",
            niV = "Nv",
            nt = "Nt",
            v = "V",
            vs = "Vs",
            V = "V_",
            Vs = "Vs",
            ["\22"] = "^V",
            ["\22s"] = "^V",
            s = "S",
            S = "S_",
            ["\19"] = "^S",
            i = "I",
            ic = "Ic",
            ix = "Ix",
            R = "R",
            Rc = "Rc",
            Rx = "Rx",
            Rv = "Rv",
            Rvc = "Rv",
            Rvx = "Rv",
            c = "C",
            cv = "Ex",
            r = "...",
            rm = "M",
            ["r?"] = "?",
            ["!"] = "!",
            t = "T",
        },
        mode_colors = {
            n = utils.colors.palette.dragonRed,
            i = utils.colors.palette.dragonGreen,
            v = utils.colors.palette.dragonAqua,
            V = utils.colors.palette.dragonAqua,
            ["\22"] = utils.colors.palette.dragonAqua,
            c = utils.colors.palette.dragonOrange,
            s = utils.colors.palette.dragonViolet,
            S = utils.colors.palette.dragonViolet,
            ["\19"] = utils.colors.palette.dragonViolet,
            R = utils.colors.palette.dragonOrange,
            r = utils.colors.palette.dragonOrange,
            ["!"] = utils.colors.palette.dragonRed,
            t = utils.colors.palette.dragonRed,
        },
    },
    -- We can now access the value of mode() that, by now, would have been
    -- computed by `init()` and use it to index our strings dictionary.
    -- note how `static` fields become just regular attributes once the
    -- component is instantiated.
    -- To be extra meticulous, we can also add some vim statusline syntax to
    -- control the padding and make sure our string is always at least 3
    -- characters long.
    provider = function(self)
        local mode = self.mode_names[self.mode]
        return "%2.4(" .. mode .. "%) "
    end,
    hl = function(self)
        local mode = self.mode:sub(1, 1) -- get only get first mode character
        return {
            bg = self.mode_colors[mode],
            -- bg = utils.colors.palette.dragonWhite,
            -- fg = utils.colors.theme.ui.bg,
            fg = utils.colors.palette.dragonBlack4,
            -- bg = utils.colors.theme.ui.fg,
            bold = true,
        }
    end,
    -- Re-evaluate the component only on ModeChanged event!
    -- Also allows the statusline to be re-evaluated when entering operator-pending mode
    update = {
        "ModeChanged",
        pattern = "*:*",
        callback = vim.schedule_wrap(function()
            vim.cmd("redrawstatus")
        end),
    },
}

local FileNameBlock = {
    init = function(self)
        self.filename = vim.api.nvim_buf_get_name(0)
    end,
}

local FileName = {
    condition = function()
        return vim.bo.filetype ~= "help" and vim.bo.filetype ~= "oil"
    end,
    provider = function(self)
        -- first, get only the filename. For other
        -- options, see :h filename-modifers
        local filename = vim.fn.fnamemodify(self.filename, ":t")
        if filename == "" then
            return "[no name]"
        end
        -- now, if the filename would occupy more than 1/4th of the available
        -- space, we trim the file path to its initials
        -- See Flexible Components section below for dynamic truncation
        if not utils.conditions.width_percent_below(#filename, 0.25) then
            filename = vim.fn.pathshorten(filename)
        end
        return "%(" .. filename .. "%)"
    end,
    -- hl = {
    --     -- fg = utils.fn.get_highlight("Directory").fg
    --     fg = utils.colors.palette.dragonBlack6,
    -- },
    hl = function()
        if utils.lsp_attached() then
            return { fg = utils.colors.palette.dragonGreen, bold = true }
        else
            return { fg = utils.colors.palette.dragonBlack6 }
        end
    end
}

local HelpFileName = {
    condition = function()
        return vim.bo.filetype == "help"
    end,
    provider = function()
        local filename = vim.api.nvim_buf_get_name(0)
        return vim.fn.fnamemodify(filename, ":t")
    end,
    hl = { fg = utils.colors.palette.dragonBlack6 },
}

local OilFileName = {
    condition = function()
        return vim.bo.filetype == "oil"
    end,
    provider = function()
        return require("oil").get_current_dir()
    end,
    hl = {
        fg = utils.colors.palette.dragonBlack6,
    },
}

FileNameBlock = utils.fn.insert(
    FileNameBlock,
    { provider = ' ' },
    FileName,
    HelpFileName,
    OilFileName,
    { provider = "%<" } -- this means that the statusline is cut here when there's not enough space
)

local MacroRec = {
    condition = function()
        return vim.fn.reg_recording() ~= "" and vim.o.cmdheight == 0
    end,
    hl = { fg = utils.colors.palette.dragonBlack5 },
    utils.fn.surround({ "[", "] " }, nil, {
        provider = function()
            return vim.fn.reg_recording()
        end,
        hl = { fg = utils.colors.palette.dragonGreen2, bold = true },
    }),
    update = {
        "RecordingEnter",
        "RecordingLeave",
    },
}

local Align = { provider = "%=" }

local FileSaved = {
    condition = function()
        return vim.bo.modified
    end,
    provider = "* ",
    hl = {
        fg = utils.colors.palette.dragonGray,
        bold = true,
    },
}

-- local Ruler = {
--     provider = " %(%l%):%c ",
--     hl = {
--         fg = utils.colors.palette.dragonBlack6
--     }
-- }

-- local Lsp = {
--     condition = utils.conditions.lsp_attached,
--     update = { 'LspAttach', 'LspDetach' },
--     -- provider = " ",
--     provider = "LSP ",
--     hl = {
--         fg = utils.colors.palette.dragonGreen,
--         bold = true
--     }
-- }

local FileType = {
    condition = function()
        local filetype = string.upper(vim.bo.filetype)
        return filetype ~= "NEOGITSTATUS"
    end,
    update = { "LspAttach", "LspDetach", "FileType", "BufEnter" },
    provider = function()
        local ft = vim.bo.filetype
        if ft == "" or ft == "oil" or string.upper(ft) == "NEOGITSTATUS" then
            return " "
        end
        return " " .. string.upper(ft) .. " "
    end,
    hl = function()
        local hl = {
            fg = utils.colors.palette.dragonRed,
            bold = true,
        }
        if utils.conditions.lsp_attached() then
            hl.fg = utils.colors.palette.dragonGreen
        end
        return hl
    end
}

local S = vim.diagnostic.severity

local Diagnostics = {
    -- condition = utils.conditions.has_diagnostics,
    init = function(self)
        self.errors = #vim.diagnostic.get(0, { severity = S.ERROR })
        self.warnings = #vim.diagnostic.get(0, { severity = S.WARN })
        self.hints = #vim.diagnostic.get(0, { severity = S.HINT })
        self.info = #vim.diagnostic.get(0, { severity = S.INFO })
    end,
    update = { "DiagnosticChanged", "BufEnter" },
    {
        provider = " ",
    },
    {
        provider = function(self)
            return self.errors .. " "
        end,
        hl = { fg = utils.colors.theme.diag.error },
    },
    {
        provider = function(self)
            return self.warnings .. " "
        end,
        hl = { fg = utils.colors.theme.diag.warning },
    },
    {
        provider = function(self)
            return self.info
        end,
        hl = { fg = utils.colors.theme.diag.info },
    },
    {
        provider = " ",
    },
}

local Git = {
    condition = utils.conditions.is_git_repo,
    init = function(self)
        self.status_dict = vim.b.gitsigns_status_dict
    end,
    hl = {
        fg = utils.colors.theme.ui.fg,
    },
    {
        provider = function(self)
            -- return " " .. self.status_dict.head .. " "
            return self.status_dict.head .. " "
        end,
        -- hl = { bold = true }
    },
    {
        provider = function(self)
            local count = self.status_dict.added or 0
            return "+" .. count .. " "
        end,
        hl = {
            bold = true,
            fg = utils.colors.theme.vcs.added,
        },
    },
    {
        provider = function(self)
            local count = self.status_dict.removed or 0
            return "-" .. count .. " "
        end,
        hl = {
            bold = true,
            fg = utils.colors.theme.vcs.removed,
        },
    },
    {
        provider = function(self)
            local count = self.status_dict.changed or 0
            return "~" .. count .. " "
        end,
        hl = {
            bold = true,
            fg = utils.colors.theme.vcs.changed,
        },
    },
}

local DefaultStatusLine = {
    -- Lsp,
    Mode,
    -- FileType,
    FileNameBlock,
    Diagnostics,
    Align,
    FileSaved,
    MacroRec,
    Git,
    hl = function()
        return {
            bg = utils.colors.theme.ui.bg,
        }
    end,
}

local InactiveStatusline = {
    condition = utils.conditions.is_not_active,
    FileNameBlock,
    FileSaved,
    Align,
    hl = function()
        return {
            bg = utils.colors.theme.ui.bg,
        }
    end,
}

local TerminalName = {
    provider = function()
        local tname, _ = vim.api.nvim_buf_get_name(0):gsub(".*:/.*/", "")
        return tname
    end,
    hl = {
        -- fg = utils.colors.palette.dragonBlue,
        fg = utils.colors.palette.dragonBlack6,
        bold = true,
    },
}

local TerminalStatusline = {
    condition = function()
        return utils.conditions.buffer_matches({ buftype = { "terminal" } })
    end,
    hl = function()
        return {
            bg = utils.colors.theme.ui.bg,
        }
    end,
    { condition = utils.conditions.is_active, Mode },
    TerminalName,
    Align,
}

return {
    fallthrough = false,
    TerminalStatusline,
    InactiveStatusline,
    DefaultStatusLine,
}
