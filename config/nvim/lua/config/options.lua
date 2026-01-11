-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--vim.opt.relativenumber = false

vim.g.autoformat = false

vim.opt.expandtab = true     -- Use spaces instead of tabs
vim.opt.shiftwidth = 4       -- Indent by 4 spaces
vim.opt.tabstop = 4          -- A tab counts as 4 spaces
vim.opt.softtabstop = 4      -- Pressing <Tab> inserts 4 spaces

vim.opt.ignorecase = false -- make searches case-sensitive
vim.opt.smartcase  = true -- but not if cases are used
