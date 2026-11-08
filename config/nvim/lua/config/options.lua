-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--vim.opt.relativenumber = false

vim.g.autoformat = false
vim.opt.laststatus = 0

vim.opt.expandtab = true     -- Use spaces instead of tabs
vim.opt.shiftwidth = 4       -- Indent by 4 spaces
vim.opt.tabstop = 4          -- A tab counts as 4 spaces
vim.opt.softtabstop = 4      -- Pressing <Tab> inserts 4 spaces

vim.opt.ignorecase = false -- make searches case-sensitive
vim.opt.smartcase  = true -- but not if cases are used

vim.opt.conceallevel = 0 -- do not conceal markdown syntax elements

-- Over SSH there is no X/Wayland clipboard, so copy via OSC 52 instead.
-- The terminal (e.g. Termux) then sets the local clipboard.
if vim.env.SSH_TTY then
  -- LazyVim disables unnamedplus over SSH, so plain yanks never reach "+.
  vim.opt.clipboard = "unnamedplus"
  local osc52 = require("vim.ui.clipboard.osc52")
  vim.g.clipboard = {
    name = "OSC 52",
    copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
    paste = { ["+"] = osc52.paste("+"), ["*"] = osc52.paste("*") },
  }
end
