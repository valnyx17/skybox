local function get_num_wraps()
    local winid = vim.api.nvim_get_current_win()

    local winfo = vim.fn.getwininfo(winid)[1]
    local bufwidth = winfo["width"] - winfo["textoff"]
    local line_length = vim.fn.strdisplaywidth(vim.fn.getline(vim.v.lnum))

    return math.floor(line_length / bufwidth)
end

return {
    "luukvbaal/statuscol.nvim",
    config = function()
        require("statuscol").setup({
            relculright = true,
            thousands = ',',
            ft_ignore = {
                "aerial",
                "help",
                "neo-tree",
                "toggleterm",
            },
            segments = {
                {
                    sign = {
                        namespace = { "diagnostic" },
                    },
                    condition = {
                        function()
                            return v.diagnostics_available() or '  '
                        end
                    }
                },
                {
                    condition = {
                        function()
                            return vim.wo.number or vim.wo.relativenumber
                        end
                    },
                    text = {
                        ' ',
                        "%=",
                        function(args)
                            local mode = vim.fn.mode()
                            local normalized_mode = vim.fn.strtrans(mode):lower():gsub("%W", "")

                            -- case 1
                            if normalized_mode ~= 'v' and args.virtnum == 0 then
                                return require("statuscol.builtin").lnumfunc(args)
                            end

                            if args.virtnum < 0 then
                                return '-'
                            end

                            local line = require("statuscol.builtin").lnumfunc(args)

                            if args.virtnum > 0 then
                                local num_wraps = get_num_wraps()

                                if args.virtnum == num_wraps then
                                    line = '└'
                                else
                                    line = '├'
                                end
                            end

                            -- Highlight cases
                            if normalized_mode == 'v' then
                                local pos_list = vim.fn.getregionpos(
                                    vim.fn.getpos('v'),
                                    vim.fn.getpos('.'),
                                    { type = mode, eol = true }
                                )
                                local s_row, e_row = pos_list[1][1][2], pos_list[#pos_list][2][2]

                                if args.lnum >= s_row and args.lnum <= e_row then
                                    return v.hl_str("CursorLineNr", line)
                                end
                            end

                            return vim.fn.line('.') == args.lnum and
                                v.hl_str("CursorLineNr", line) or
                                v.hl_str("LineNr", line)
                        end,
                        ' ',
                    }
                },
                {
                    sign = {
                        namespace = { "gitsigns" },
                        maxwidth = 1,
                        colwidth = 1,
                    },
                    condition = {
                        require("statuscol.builtin").not_empty
                        -- function()
                        --     local root = v.get_path_root(vim.api.nvim_buf_get_name(0))
                        --     return v.get_git_remote_name(root) or ' '
                        -- end
                    }
                },
                { text = { " " }, hl = "Normal" },
                {
                    text = { require("statuscol.builtin").foldfunc },
                    condition = {
                        function()
                            return vim.api.nvim_get_option_value("modifiable", { buf = 0 }) or ' '
                        end
                    }
                },
                { text = { " " }, hl = "Normal" }
            }
        })
    end
}
