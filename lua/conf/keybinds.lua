---@alias mappingvalue (string) | fun() | fun(): string
---@alias mode string|string[]

---creates a keymapping
---@param m mode
---@param k string
---@param v mappingvalue
---@param opts table?
local function map(m, k, v, opts)
    vim.keymap.set(m, k, v, vim.tbl_deep_extend("force", { silent = true, noremap = true }, opts or {}))
end

---creates a mapper
---@param m mode
---@return fun(k: string, v: mappingvalue, opts: table?)
local function create_mapper(m)
    return function(k, v, opts)
        map(m, k, v, opts)
    end
end

--- normal mode keymapper
local mapn = create_mapper("n")

local autoindent = function(key)
    return function()
        return not vim.api.nvim_get_current_line():match("%g") and "cc" or key
    end
end

for _, k in ipairs({ "I", "i", "A", "a" }) do
    mapn(k, autoindent(k), { expr = true })
end

-- normal mode
mapn("<C-h>", "<cmd>NvimTmuxNavigateLeft<CR>", { desc = "Navigate Left" })
mapn("<C-j>", "<cmd>NvimTmuxNavigateDown<CR>", { desc = "Navigate Down" })
mapn("<C-k>", "<cmd>NvimTmuxNavigateUp<CR>", { desc = "Navigate Up" })
mapn("<C-l>", "<cmd>NvimTmuxNavigateRight<CR>", { desc = "Navigate Right" })

mapn("<leader>r", [[:%s/\<<C-r><C-w>\>//g<Left><Left>]], { desc = "search and replace word under cursor" })
mapn("<leader>cc", [[:%s/\s\+$//e<cr>]], { desc = "remove trailing spaces" })

mapn("x", '"_dl')
mapn("X", '"_dh')

mapn("<C-d>", "<C-d>zz")
mapn("<C-u>", "<C-u>zz")

mapn("YY", "va{Vy")

mapn("n", "nzz")
mapn("N", "Nzz")
mapn("*", "*zz")
mapn("#", "#zz")
mapn("g*", "g*zz")
mapn("g#", "g#zz")

mapn("<C-M-h>", ":vert resize +2<CR>")
mapn("<C-M-j>", ":resize -2<CR>")
mapn("<C-M-k>", ":resize +2<CR>")
mapn("<C-M-l>", ":vert resize -2<CR>")

--- normal & terminal mode keymapper
local mapnt = create_mapper({ "n", "t" })

-- better tabs
-- mapnt("<leader>n", "<cmd>tabnew<CR>", { desc = "new tab" })
-- tab and shift tab go back and forward buffers?? in nvchad
mapnt("<leader><Tab>n", "<cmd>tabnext<CR>", { desc = "next tab" })
mapnt("<leader><Tab>p", "<cmd>tabprevious<CR>", { desc = "previous tab" })
mapnt("<leader><Tab><Tab>", "<cmd>tabnew<CR>", { desc = "new tab" })
mapnt("<localleader>c", "<cmd>tabclose<CR>", { desc = "close tab" })
mapnt("<leader><Tab>1", "1gt", { desc = "switch to tab 1" })
mapnt("<leader><Tab>2", "2gt", { desc = "switch to tab 2" })
mapnt("<leader><Tab>3", "3gt", { desc = "switch to tab 3" })
mapnt("<leader><Tab>4", "4gt", { desc = "switch to tab 4" })
mapnt("<leader><Tab>5", "5gt", { desc = "switch to tab 5" })
mapnt("<leader><Tab>6", "6gt", { desc = "switch to tab 6" })
mapnt("<leader><Tab>7", "7gt", { desc = "switch to tab 7" })
mapnt("<leader><Tab>8", "8gt", { desc = "switch to tab 8" })
mapnt("<leader><Tab>9", "9gt", { desc = "switch to tab 9" })
mapnt("<leader><Tab>0", "10gt", { desc = "switch to tab 10" })

map({ "n", "v" }, "p", "p=`]", { remap = true })
map({ "n", "v" }, "P", "P=`]", { remap = true })

local function fish_style_abbr(abbr, expansion)
    map("ca", abbr, function()
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
fish_style_abbr("V", "vert")
fish_style_abbr("VS", "vert sb")
fish_style_abbr("s", "s/g<Left><Left>")
fish_style_abbr("%s", "%s/g<Left><Left>")
fish_style_abbr("w", function()
    local auto_p = "w ++p"
    if vim.env.USER == "root" then
        return auto_p
    end
    if vim.bo.filetype == "oil" then
        return "w"
    end
    return auto_p
end)
fish_style_abbr("!", "term")
fish_style_abbr("=", "term")
fish_style_abbr("cdo", "cdo | update<Left><Left><Left><Left><Left><Left><Left><Left><Left>")
fish_style_abbr("cfdo", "cfdo | update<Left><Left><Left><Left><Left><Left><Left><Left><Left>")

--- visual mode mapper
local mapv = create_mapper("v")

mapv("J", ":m '>+1<CR>gv=gv")
mapv("K", ":m '<-2<CR>gv=gv")
mapv("<", "<gv")
mapv(">", ">gv")
mapv("p", '"_dp')
mapv("P", '"_dP')
mapv("x", '"_x')
mapv("X", '"_X')

map("i", "<C-Return>", "<Esc>o")
map("i", "<C-S-Return>", "<Esc>O")
map("i", "<C-_>", "<Esc>:normal gcc<CR>A")

map({ "n", "x", "o" }, "H", "^")
map({ "n", "x", "o" }, "L", "g_")
