local keymap = require('skybox.util').keymap
local k = vim.keycode

--- normal mode keymapper
local nmap = keymap.create_mapper("n")

-- normal mode
-- navigation with support for whether or not I have nvimtmuxnavigate
if vim.fn.exists(":NvimTmuxNavigateRight") ~= 0 then
  nmap("<C-h>", "<cmd>NvimTmuxNavigateLeft<CR>", { desc = "Navigate Left" })
  nmap("<C-j>", "<cmd>NvimTmuxNavigateDown<CR>", { desc = "Navigate Down" })
  nmap("<C-k>", "<cmd>NvimTmuxNavigateUp<CR>", { desc = "Navigate Up" })
  nmap("<C-l>", "<cmd>NvimTmuxNavigateRight<CR>", { desc = "Navigate Right" })
else
  nmap("<C-h>", "<c-w><c-h>", { desc = "Navigate Left" })
  nmap("<C-j>", "<c-w><c-j>", { desc = "Navigate Down" })
  nmap("<C-k>", "<c-w><c-k>", { desc = "Navigate Up" })
  nmap("<C-l>", "<c-w><c-l>", { desc = "Navigate Right" })
end

-- deal with line wraps
nmap("j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
nmap("k", "v:count == 0 ? 'gk' : 'k'", { expr = true })

-- save
nmap("<C-s>", "<cmd>w<CR>", { desc = "write file" })

nmap("<leader>|", "<C-w>v", { desc = "vertical split" })
nmap("<leader>-", "<C-w>s", { desc = "horizontal split" })
nmap("<leader>sv", "<C-w>v", { desc = "vertical split" })
nmap("<leader>sh", "<C-w>s", { desc = "horizontal split" })
nmap("<leader>se", "<C-w>=", { desc = "make splits equal size" })
nmap("<leader>sd", "<cmd>close<cr>", { desc = "close current split" })

-- various edit commands
nmap(
  "<leader>er",
  [[:%s/\<<C-r><C-w>\>//g<Left><Left>]],
  { desc = "search and replace word under cursor" }
)
nmap("<leader>ec", [[:%s/\s\+$//e<cr>]], { desc = "remove trailing spaces" })

nmap("x", '"_dl')
nmap("X", '"_dh')

nmap("<C-d>", "<C-d>zz")
nmap("<C-u>", "<C-u>zz")
nmap("n", "nzz")
nmap("N", "Nzz")
nmap("*", "*zz")
nmap("#", "#zz")
nmap("g*", "g*zz")
nmap("g#", "g#zz")

nmap("YY", "va{Vy")

nmap("<C-M-h>", ":vert resize +2<CR>", { desc = "resize split left" })
nmap("<C-M-j>", ":resize -2<CR>", { desc = "resize split down" })
nmap("<C-M-k>", ":resize +2<CR>", { desc = "resize split up" })
nmap("<C-M-l>", ":vert resize -2<CR>", { desc = "resize split right" })

--- normal & terminal mode keymapper
local nmapt = keymap.create_mapper({ "n", "t" })

-- better tabs
-- mapnt("<leader>n", "<cmd>tabnew<CR>", { desc = "new tab" })
-- tab and shift tab go back and forward buffers?? in nvchad
nmapt("<leader>to", "<cmd>tabnew<CR>", { desc = "new tab" })
nmapt("<leader>tf", "<cmd>tabnew %<CR>", { desc = "open current buffer in new tab" })
nmapt("<leader>td", "<cmd>tabclose<CR>", { desc = "close tab" })
nmapt("<leader>tn", "<cmd>tabnext<CR>", { desc = "next tab" })
nmapt("<leader>tp", "<cmd>tabprevious<CR>", { desc = "previous tab" })
-- nmapt("<leader>t1", "1gt", { desc = "switch to tab 1" })
-- nmapt("<leader>t2", "2gt", { desc = "switch to tab 2" })
-- nmapt("<leader>t3", "3gt", { desc = "switch to tab 3" })
-- nmapt("<leader>t4", "4gt", { desc = "switch to tab 4" })
-- nmapt("<leader>t5", "5gt", { desc = "switch to tab 5" })
-- nmapt("<leader>t6", "6gt", { desc = "switch to tab 6" })
-- nmapt("<leader>t7", "7gt", { desc = "switch to tab 7" })
-- nmapt("<leader>t8", "8gt", { desc = "switch to tab 8" })
-- nmapt("<leader>t9", "9gt", { desc = "switch to tab 9" })
-- nmapt("<leader>t0", "10gt", { desc = "switch to tab 10" })

keymap.set({ "n", "v" }, "p", "p=`]", { remap = true })
keymap.set({ "n", "v" }, "P", "P=`]", { remap = true })

-- fish_style_abbr("L", "Lazy")
keymap.set_fish_style_abbr("V", "vert")
keymap.set_fish_style_abbr("s", "s/g<Left><Left>")
keymap.set_fish_style_abbr("%s", "%s/g<Left><Left>")
keymap.set_fish_style_abbr("cdo", "cdo | update<Left><Left><Left><Left><Left><Left><Left><Left><Left>")
keymap.set_fish_style_abbr("cfdo", "cfdo | update<Left><Left><Left><Left><Left><Left><Left><Left><Left>")

--- visual mode mapper
local vmap = keymap.create_mapper("v")

vmap("J", ":m '>+1<CR>gv=gv")
vmap("K", ":m '<-2<CR>gv=gv")
vmap("<", "<gv")
vmap(">", ">gv")
vmap("p", '"_dkp')
vmap("P", '"_dkP')
vmap("x", '"_x')
vmap("X", '"_X')
vmap("j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
vmap("k", "v:count == 0 ? 'gk' : 'k'", { expr = true })

local imap = keymap.create_mapper("i")
imap("<C-Return>", "<Esc>o")
imap("<C-S-Return>", "<Esc>O")
imap("<C-_>", "<Esc>:normal gcc<CR>A")
keymap.set({"x", "o"}, "<C-c>", "\"+y")
keymap.set({"x", "o"}, "<C-c>", "\"+y")

keymap.set({ "n", "x", "o" }, "H", "^")
keymap.set({ "n", "x", "o" }, "L", "g_")
