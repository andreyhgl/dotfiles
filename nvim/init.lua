-- ~/.config/nvim/init.lua  (tracked in dotfiles, symlinked by install.sh)
-- Neovim config: syntax highlighting for bash, R, and Nextflow.

-- baseline settings.
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.mouse = "a"

-- Bootstrap lazy.nvim (the plugin manager) if it isn't installed yet.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Nextflow filetype detection (before plugins, so highlighting attaches).
require("config.filetypes")

-- Load plugin specs from lua/config/plugins.lua
require("lazy").setup(require("config.plugins"))
