local keymap = viv.keymap
local nmap = keymap.setn
local vmap = keymap.setv
local nmapt = keymap.setnt
local imap = keymap.seti

-- navigation with support for whether or not I have Navigator
local keys = { "h", "j", "k", "l" }
local dirs = { "Left", "Down", "Up", "Right" }
local nav = "Navigator"
for i = 1, 4 do
  nmap("<C-" .. keys[i] .. ">",
    (vim.fn.exists(":" .. nav .. dirs[i]) ~= 0) and "<cmd>" .. nav .. dirs[i] .. "<CR>" or "<c-w><c-" .. keys[i] .. ">",
    { desc = "Navigate " .. dirs[i] })
end

-- split manipulation
nmap("<leader>|", "<C-w>v", { desc = "vertical split" })
nmap("<leader>-", "<C-w>s", { desc = "horizontal split" })
nmap("<localleader>sv", "<C-w>v", { desc = "vertical split" })
nmap("<localleader>sh", "<C-w>s", { desc = "horizontal split" })
nmap("<localleader>se", "<C-w>=", { desc = "make splits equal size" })
nmap("<localleader>sd", "<cmd>close<cr>", { desc = "close current split" })
-- resize splits
nmap("<C-M-h>", ":vert resize +2<CR>", { desc = "resize split left" })
nmap("<C-M-j>", ":resize -2<CR>", { desc = "resize split down" })
nmap("<C-M-k>", ":resize +2<CR>", { desc = "resize split up" })
nmap("<C-M-l>", ":vert resize -2<CR>", { desc = "resize split right" })

-- tab manipulation
nmapt("<localleader>to", "<cmd>tabnew<CR>", { desc = "new tab" })
nmapt("<localleader>tf", "<cmd>tabnew %<CR>", { desc = "open current buffer in new tab" })
nmapt("<localleader>td", "<cmd>tabclose<CR>", { desc = "close tab" })
nmapt("<localleader>tn", "<cmd>tabnext<CR>", { desc = "next tab" })
nmapt("<localleader>tp", "<cmd>tabprevious<CR>", { desc = "previous tab" })
---[[
for i = 1, 10 do
  nmapt("<localleader>t" .. (i == 10 and 0 or i), i .. "gt", { desc = "switch to tab " .. i })
end
--]]

-- buffer manipulation
nmapt("<localleader>bd", "<cmd>bdelete<CR>", { desc = "delete buffer" })
nmapt("<localleader>bn", "<cmd>enew<CR>", { desc = "new buffer" })
nmap("<C-s>", "<cmd>w<CR>", { desc = "write file" })

-- center lines after certain motions
nmap("<C-d>", "<C-d>zzzv")
nmap("<C-u>", "<C-u>zzzv")
nmap("n", "nzzzv")
nmap("N", "Nzzzv")
nmap("*", "*zzzv")
nmap("#", "#zzzv")
nmap("g*", "g*zzzv")
nmap("g#", "g#zzzv")
-- move by screen line, not text line
keymap.setnv("j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
keymap.setnv("k", "v:count == 0 ? 'gk' : 'k'", { expr = true })

-- text manipulation
-- various edit commands
nmap("<leader>er", [[:%s/\<<C-r><C-w>\>//g<Left><Left>]], { desc = "search and replace word under cursor" })
nmap("<leader>ec", [[:%s/\s\+$//e<cr>]], { desc = "remove trailing spaces" })
-- delete without affecting clipboard
nmap("x", '"_dl')
nmap("X", '"_dh')
vmap("x", '"_x')
vmap("X", '"_X')
-- paste and autoindent
nmap("P", "P=`]", { noremap = true, silent = true })
nmap("p", "p=`]", { noremap = true, silent = true })
vmap("p", 'kp=`]', { noremap = true, silent = true })
vmap("P", 'P=`]', { noremap = true, silent = true })
-- create new line below/above
imap("<C-Return>", "<Esc>o")
imap("<C-S-Return>", "<Esc>O")
-- copy
keymap.setvxo("<C-c>", '"+y')
nmap("<C-c>", 'V"+y')
-- start/end of line
keymap.setnxo("H", "^")
keymap.setnxo("L", "g_")

-- various cmdline abbreviations
keymap.cmdline_abbr("s", "s/g<Left><Left>")
keymap.cmdline_abbr("%s", "%s/g<Left><Left>")
keymap.cmdline_abbr("cdo", "cdo | update<Left><Left><Left><Left><Left><Left><Left><Left><Left>")
keymap.cmdline_abbr("cfdo", "cfdo | update<Left><Left><Left><Left><Left><Left><Left><Left><Left>")
