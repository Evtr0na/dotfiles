-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- lua/config/options.lua




--------------------------------
--vim 
--------------------------------

-- vim.opt.autochdir = true
vim.g.mapleader = " "
vim.g.maplocalleader = " "
--vim.o.guifont = "Sarasa Term SC:h14"
vim.diagnostic.config({
  signs = false,
})

vim.opt.number = true       -- 显示当前行的绝对行号
vim.opt.relativenumber = true  -- 显示相对行号（光标上下行显示距离）

--------------------------------
-- neovide
--------------------------------

if vim.g.neovide then

  vim.g.neovide_cursor_animation_length = 0
  vim.g.neovide_cursor_short_animation_length = 0
  vim.g.neovide_scroll_animation_length = 0
  vim.g.neovide_cursor_animate_in_insert_mode = false
  vim.g.neovide_cursor_animate_command_line = false
end
-- 下面继续你原来的 options
