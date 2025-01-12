-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.scrolloff = 999
-- filetypes
vim.filetype.add({
  extension = {
    mdx = "mdx",
  },
})

-- edgy.nvim recommended option
vim.opt.splitkeep = "screen"

-- remove mouse
vim.opt.mouse = ""

vim.g.lazyvim_picker = "fzf"
