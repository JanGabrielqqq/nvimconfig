-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- NOTE: NORMAL MODE
vim.api.nvim_set_keymap("x", "p", '"_dP', { noremap = true, silent = true })
vim.keymap.set("n", "<F2>", "<Cmd>lua vim.lsp.buf.rename()<CR>", { noremap = true, silent = true })
vim.keymap.set(
  "n",
  "<leader>ut",
  "<Cmd>TailwindColorsToggle<CR>",
  { noremap = true, desc = "Toggle TailwindCss Highlights" }
)
vim.keymap.set(
  "n",
  "ghd",
  "<Cmd>lua vim.lsp.buf.hover()<CR>",
  { noremap = true, silent = true, desc = "Show Definition" }
)

vim.keymap.set("n", "ghi", "<Cmd>Inspect<CR>", { noremap = true, silent = true, desc = "Show HL Inspect" })

vim.api.nvim_set_keymap("n", "<leader>SA", "<Cmd>wa<CR>", { noremap = true, silent = true, desc = "Save All Buffer" })
vim.api.nvim_set_keymap(
  "n",
  "<leader>Sa",
  "<Cmd>noa wa<CR>",
  { noremap = true, silent = true, desc = "No AutoCommand Save All Buffer" }
)

vim.keymap.set("n", "<leader>yf", function()
  local path = vim.fn.expand("%:.")
  vim.fn.setreg("+", path)
  vim.notify("Copied to clipboard: " .. path)
end, { desc = "Copy file path" })

--  NOTE: INSERT MODE
vim.keymap.set("i", "<C-H>", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-o>db", true, true, true), "n", true)
end, { noremap = true, silent = true })

vim.keymap.set("i", "<C-Del>", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-o>dw", true, true, true), "n", true)
end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>r", "<Cmd>FzfLua resume<CR>", { noremap = true, silent = true, desc = "FZF Resume" })
