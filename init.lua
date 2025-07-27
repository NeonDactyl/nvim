vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true

vim.cmd("highlight Normal guibg=NONE")
vim.cmd("highlight NormalFlaot guibg=NONE")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.keymap.set("n", "<Space>", "<Nop>", { silent = true, remap = false})

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

function OpenMarkdownPreview(url)
  vim.cmd("silent ! firefox --new-window " .. url)
end

vim.g.mkdp_echo_preview_url = 1

require("neondactyl.plugins")
