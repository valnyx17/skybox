local keymap = require('skybox.util').keymap
local k = vim.keycode

--- normal mode keymapper
local nmap = keymap.create_mapper("n")
--- visual mode mapper
local vmap = keymap.create_mapper("v")
--- normal & terminal mode keymapper
local nmapt = keymap.create_mapper({ "n", "t" })
--- insert mode mapper
local imap = keymap.create_mapper("i")

-- navigation with support for whether or not I have nvimtmuxnavigate
local keys = { "h", "j", "k", "l" }
local dirs = { "Left", "Down", "Up", "Right" }
local nav = "NvimTmuxNavigate"
for i=1,4 do
  nmap("<C-" .. keys[i] .. ">", (vim.fn.exists(":" .. nav .. dirs[i]) ~= 0) and "<cmd>" .. nav .. dirs[i] .. "<CR>" or "<c-w><c-" .. keys[i] .. ">", { desc = "Navigate " .. dirs[i] })
end

-- split manipulation
nmap("<leader>|", "<C-w>v", { desc = "vertical split" })
nmap("<leader>-", "<C-w>s", { desc = "horizontal split" })
nmap("<leader>sv", "<C-w>v", { desc = "vertical split" })
nmap("<leader>sh", "<C-w>s", { desc = "horizontal split" })
nmap("<leader>se", "<C-w>=", { desc = "make splits equal size" })
nmap("<leader>sd", "<cmd>close<cr>", { desc = "close current split" })
-- resize splits
nmap("<C-M-h>", ":vert resize +2<CR>", { desc = "resize split left" })
nmap("<C-M-j>", ":resize -2<CR>", { desc = "resize split down" })
nmap("<C-M-k>", ":resize +2<CR>", { desc = "resize split up" })
nmap("<C-M-l>", ":vert resize -2<CR>", { desc = "resize split right" })

-- tab manipulation
nmapt("<leader>to", "<cmd>tabnew<CR>", { desc = "new tab" })
nmapt("<leader>tf", "<cmd>tabnew %<CR>", { desc = "open current buffer in new tab" })
nmapt("<leader>td", "<cmd>tabclose<CR>", { desc = "close tab" })
nmapt("<leader>tn", "<cmd>tabnext<CR>", { desc = "next tab" })
nmapt("<leader>tp", "<cmd>tabprevious<CR>", { desc = "previous tab" })
---[[
for i=1,10 do
  nmapt("<leader>t" .. i == 10 and 0 or i, i .. "gt", { desc = "switch to tab " .. i})
end
--]]

-- buffer manipulation
if (vim.fn.exists(":FzfLua")) then nmapt("<leader>bf", "<cmd>FzfLua buffers<CR>", { desc = "find buffer" }) end
nmapt("<leader>bd", "<cmd>bdelete<CR>", { desc = "delete buffer" })
nmapt("<leader>bn", "<cmd>enew<CR>", { desc = "new buffer" })
nmap("<C-s>", "<cmd>w<CR>", { desc = "write file" })

-- center lines after certain motions
nmap("<C-d>", "<C-d>zz")
nmap("<C-u>", "<C-u>zz")
nmap("n", "nzz")
nmap("N", "Nzz")
nmap("*", "*zz")
nmap("#", "#zz")
nmap("g*", "g*zz")
nmap("g#", "g#zz")
-- move by screen line, not text line
keymap.set({"n", "v"}, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
keymap.set({"n", "v"}, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })

-- text manipulation
-- various edit commands
nmap("<leader>er", [[:%s/\<<C-r><C-w>\>//g<Left><Left>]], { desc = "search and replace word under cursor" })
nmap("<leader>ec", [[:%s/\s\+$//e<cr>]], { desc = "remove trailing spaces" })
-- delete without affecting clipboard
nmap("x", '"_dl')
nmap("X", '"_dh')
vmap("p", '"_dkp')
vmap("P", '"_dkP')
vmap("x", '"_x')
vmap("X", '"_X')
-- paste and autoindent
keymap.set({ "n", "v" }, "p", "p=`]", { remap = true })
keymap.set({ "n", "v" }, "P", "P=`]", { remap = true })
-- TODO: make mini.move autoremove these
-- line movement
vmap("J", ":m '>+1<CR>gv=gv")
vmap("K", ":m '<-2<CR>gv=gv")
vmap("<", "<gv")
vmap(">", ">gv")
-- create new line below/above
imap("<C-Return>", "<Esc>o")
imap("<C-S-Return>", "<Esc>O")
-- copy
keymap.set({"v", "x", "o"}, "<C-c>", '"+y')
nmap("<C-c>", 'V"+y')
-- start/end of line
keymap.set({ "n", "x", "o" }, "H", "^")
keymap.set({ "n", "x", "o" }, "L", "g_")

-- various cmdline abbreviations
keymap.set_fish_style_abbr("vh", "vert h")
keymap.set_fish_style_abbr("s", "s/g<Left><Left>")
keymap.set_fish_style_abbr("%s", "%s/g<Left><Left>")
keymap.set_fish_style_abbr("cdo", "cdo | update<Left><Left><Left><Left><Left><Left><Left><Left><Left>")
keymap.set_fish_style_abbr("cfdo", "cfdo | update<Left><Left><Left><Left><Left><Left><Left><Left><Left>")