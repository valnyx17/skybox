---
-- @file init.lua
--
-- @brief
-- entry point for vsky
--
-- @author valnyx
--

vim.loader.enable()
require("sky.globals")
vim.g.mapleader = " "
vim.g.maplocalleader = ","
require("sky.lazy")
