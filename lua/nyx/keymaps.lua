---@alias mappingvalue (string) | fun() | fun(): string
---@alias mode string|string[]

local keymap = {}

---creates a keymapping
---@param m mode
---@param k string
---@param v mappingvalue
---@param opts table?
function keymap.set(m, k, v, opts)
    vim.keymap.set(m, k, v, vim.tbl_deep_extend("force", { silent = true, noremap = true }, opts or {}))
end

---creates a mapper
---@param m mode
---@return fun(k: string, v: mappingvalue, opts: table?)
function keymap.create_mapper(m)
    return function(k, v, opts)
        keymap.set(m, k, v, opts)
    end
end

--- normal mode keymapper
keymap.setn = keymap.create_mapper("n")

local autoindent = function(key)
    return function()
        return not vim.api.nvim_get_current_line():match("%g") and "cc" or key
    end
end

for _, k in ipairs({ "I", "i", "A", "a" }) do
    keymap.setn(k, autoindent(k), { expr = true })
end

-- normal mode
keymap.setn("<C-h>", "<cmd>NvimTmuxNavigateLeft<CR>", { desc = "Navigate Left" })
keymap.setn("<C-j>", "<cmd>NvimTmuxNavigateDown<CR>", { desc = "Navigate Down" })
keymap.setn("<C-k>", "<cmd>NvimTmuxNavigateUp<CR>", { desc = "Navigate Up" })
keymap.setn("<C-l>", "<cmd>NvimTmuxNavigateRight<CR>", { desc = "Navigate Right" })

keymap.setn("<leader>fs", "<cmd>w<CR>", { desc = "write file" })
keymap.setn("<leader>fS", "<cmd>w!<CR>", { desc = "write file (force)" })
keymap.setn("<leader>fq", "<cmd>q<CR>", { desc = "quit file" })
keymap.setn("<leader>fQ", "<cmd>q!<CR>", { desc = "quit file (force)" })

keymap.setn("<leader>|", "<C-w>v", { desc = "vertical split" })
keymap.setn("<leader>-", "<C-w>s", { desc = "horizontal split" })
keymap.setn("<leader>sv", "<C-w>v", { desc = "vertical split" })
keymap.setn("<leader>sh", "<C-w>s", { desc = "horizontal split" })
keymap.setn("<leader>se", "<C-w>=", { desc = "make splits equal size" })
keymap.setn("<leader>sd", "<cmd>close<cr>", { desc = "close current split" })

keymap.setn("<leader>er", [[:%s/\<<C-r><C-w>\>//g<Left><Left>]], { desc = "search and replace word under cursor" })
keymap.setn("<leader>ec", [[:%s/\s\+$//e<cr>]], { desc = "remove trailing spaces" })

keymap.setn("x", '"_dl')
keymap.setn("X", '"_dh')

keymap.setn("<C-d>", "<C-d>zz")
keymap.setn("<C-u>", "<C-u>zz")
keymap.setn("n", "nzz")
keymap.setn("N", "Nzz")
keymap.setn("*", "*zz")
keymap.setn("#", "#zz")
keymap.setn("g*", "g*zz")
keymap.setn("g#", "g#zz")

keymap.setn("YY", "va{Vy")

keymap.setn("<C-M-h>", ":vert resize +2<CR>")
keymap.setn("<C-M-j>", ":resize -2<CR>")
keymap.setn("<C-M-k>", ":resize +2<CR>")
keymap.setn("<C-M-l>", ":vert resize -2<CR>")

--- normal & terminal mode keymapper
keymap.setnt = keymap.create_mapper({ "n", "t" })

-- better tabs
-- mapnt("<leader>n", "<cmd>tabnew<CR>", { desc = "new tab" })
-- tab and shift tab go back and forward buffers?? in nvchad
keymap.setnt("<leader>to", "<cmd>tabnew<CR>", { desc = "new tab" })
keymap.setnt("<leader>tf", "<cmd>tabnew %<CR>", { desc = "open current buffer in new tab" })
keymap.setnt("<leader>td", "<cmd>tabclose<CR>", { desc = "close tab" })
keymap.setnt("<leader>tn", "<cmd>tabnext<CR>", { desc = "next tab" })
keymap.setnt("<leader>tp", "<cmd>tabprevious<CR>", { desc = "previous tab" })
-- keymap.setnt("<leader>t1", "1gt", { desc = "switch to tab 1" })
-- keymap.setnt("<leader>t2", "2gt", { desc = "switch to tab 2" })
-- keymap.setnt("<leader>t3", "3gt", { desc = "switch to tab 3" })
-- keymap.setnt("<leader>t4", "4gt", { desc = "switch to tab 4" })
-- keymap.setnt("<leader>t5", "5gt", { desc = "switch to tab 5" })
-- keymap.setnt("<leader>t6", "6gt", { desc = "switch to tab 6" })
-- keymap.setnt("<leader>t7", "7gt", { desc = "switch to tab 7" })
-- keymap.setnt("<leader>t8", "8gt", { desc = "switch to tab 8" })
-- keymap.setnt("<leader>t9", "9gt", { desc = "switch to tab 9" })
-- keymap.setnt("<leader>t0", "10gt", { desc = "switch to tab 10" })

keymap.set({ "n", "v" }, "p", "p=`]", { remap = true })
keymap.set({ "n", "v" }, "P", "P=`]", { remap = true })

function keymap.set_fish_style_abbr(abbr, expansion)
    keymap.set("ca", abbr, function()
        local cmdline = vim.fn.getcmdline()
        local first_word = cmdline:match("%S+")
        local typing_command = vim.fn.getcmdtype() == ":" and vim.fn.getcmdpos() == (#first_word + 1)
        if not typing_command then
            return abbr
        end
        if type(expansion) == "function" then
            return expansion() or abbr
        end
        return expansion
    end, { remap = false, expr = true })
end

-- fish_style_abbr("L", "Lazy")
keymap.set_fish_style_abbr("V", "vert")
keymap.set_fish_style_abbr("VS", "vert sb")
keymap.set_fish_style_abbr("s", "s/g<Left><Left>")
keymap.set_fish_style_abbr("%s", "%s/g<Left><Left>")
keymap.set_fish_style_abbr("w", function()
    local auto_p = "w ++p"
    if vim.env.USER == "root" then
        return auto_p
    end
    if vim.bo.filetype == "oil" then
        return "w"
    end
    return auto_p
end)
keymap.set_fish_style_abbr("!", "term")
keymap.set_fish_style_abbr("=", "term")
keymap.set_fish_style_abbr("cdo", "cdo | update<Left><Left><Left><Left><Left><Left><Left><Left><Left>")
keymap.set_fish_style_abbr("cfdo", "cfdo | update<Left><Left><Left><Left><Left><Left><Left><Left><Left>")

--- visual mode mapper
keymap.setv = keymap.create_mapper("v")

keymap.setv("J", ":m '>+1<CR>gv=gv")
keymap.setv("K", ":m '<-2<CR>gv=gv")
keymap.setv("<", "<gv")
keymap.setv(">", ">gv")
keymap.setv("p", '"_dp')
keymap.setv("P", '"_dP')
keymap.setv("x", '"_x')
keymap.setv("X", '"_X')

keymap.set("i", "<C-Return>", "<Esc>o")
keymap.set("i", "<C-S-Return>", "<Esc>O")
keymap.set("i", "<C-_>", "<Esc>:normal gcc<CR>A")

keymap.set({ "n", "x", "o" }, "H", "^")
keymap.set({ "n", "x", "o" }, "L", "g_")
