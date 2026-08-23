-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- ~/.config/nvim/lua/config/keymaps.lua
--
local map = vim.keymap.set

-- 默认 y/d/p 和系统剪贴板共享 (+寄存器 = Ctrl+C剪贴板)
vim.opt.clipboard = "unnamedplus"
-- local del = vim.keymap.del

-- =========================================================
-- 基础设置
-- =========================================================

-- 你 VS Code 里的 jj -> Esc
map("i", "jj", "<Esc>", { desc = "Exit Insert Mode" })

-- =========================================================
-- VS Code 风格快捷键
-- =========================================================

map("n", "<C-a>", "ggVG", { desc = "Select All" })
map("x", "<C-a>", "<Esc>ggVG", { desc = "Select All" })


map("n", "<leader>q", "<C-w>c", {
  desc = "Close Window",
})

map("n", "Q", "<cmd>confirm bdelete<cr>", {
  desc = "Close Buffer",
})

-- =========================================================
-- Ctrl + H/J/K/L
-- =========================================================

map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- =========================================================
-- 搜索-Search
-- =========================================================

map("n", "<leader>z", function()
  require("telescope").extensions.zoxide.list()
end, { desc = "Zoxide jump" })


-- Ctrl+Tab 显示缓冲区列表
-- 添加 buffers
map("n", "<leader>b", function()
  require("telescope.builtin").buffers()
end, { desc = "List Buffers" })


-- 添加 help_tags
map("n", "<leader>h", function()
  require("telescope.builtin").help_tags()
end, { desc = "Help Tags" })

-- 添加 zoxide list
map("n", "<leader>z", function()
  require("telescope").extensions.zoxide.list()
end, { desc = "Zoxide jump" })

-- Space + O
map("n", "<leader>o", function()
  require("telescope.builtin").lsp_document_symbols()
end, { desc = "Document Symbols" })

-- Space + F
map("n", "<leader>f", function()
  require("telescope.builtin").find_files()
end, { desc = "Find File" })

-- Space + J
map("n", "<leader>j", function()
  require("telescope.builtin").live_grep()
end, { desc = "Search Text" })

-- Ctrl+N 清掉搜索高亮
map("n", "<C-n>", "<cmd>nohlsearch<cr>", { desc = "Clear Search Highlight" })

-- =========================================================
-- 文件
-- =========================================================

-- Space + W 保存
-- map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save File" })
map("n", "<C-s>", "<cmd>w<cr>", {desc = "Save File",})
-- Space + E Explorer
--
map("n", "<leader>e", "<cmd>Neotree toggle reveal<cr>", {
  desc = "Explorer",
})

-- =========================================================
-- 编辑
-- =========================================================

-- Space + C 注释
map({ "n", "x" }, "<leader>c", "gcc", {
  remap = true,
  desc = "Comment Line",
})

-- Space + R 重命名
map("n", "<leader>r", vim.lsp.buf.rename, {
  desc = "Rename Symbol",
})

-- Space + =
-- 格式化
map("n", "<leader>=", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format Document" })

-- =========================================================
-- Visual 模式
-- =========================================================

-- p：粘贴后不覆盖寄存器
map("x", "p", '"_dP', {
  desc = "Paste Without Overwriting Register",
})

-- >
map("x", ">", ">gv", {
  desc = "Indent",
})

-- <
map("x", "<", "<gv", {
  desc = "Outdent",
})

-- J：选中行向下移动
map("x", "J", ":m '>+1<CR>gv=gv", {
  desc = "Move Selection Down",
})

-- K：选中行向上移动
map("x", "K", ":m '<-2<CR>gv=gv", {
  desc = "Move Selection Up",
})

-- =========================================================
-- 标签 / Buffer
-- =========================================================
map("n", "<S-h>", "<cmd>bprevious<cr>", {
  desc = "Previous Buffer",
})

map("n", "<S-l>", "<cmd>bnext<cr>", {
  desc = "Next Buffer",
})

-- gh / gl
map("n", "gh", "<cmd>bprevious<cr>", {
  desc = "Previous Buffer",
})

map("n", "gl", "<cmd>bnext<cr>", {
  desc = "Next Buffer",
})


-- =========================================================
-- 分屏
-- =========================================================

-- Space + s + v
map("n", "<leader>sv", "<cmd>vsplit<cr>", {
  desc = "Split Right",
})

-- Space + s + h
map("n", "<leader>sh", "<cmd>split<cr>", {
  desc = "Split Down",
})


-- Space + s + m
-- VS Code toggleMaximizeEditorGroup
map("n", "<leader>sm", "<cmd>MaximizerToggle<cr>", {
  desc = "Toggle Maximize Window",
})


-- Space + s + =
map("n", "<leader>s=", "<C-w>=", {
  desc = "Equal Window Sizes",
})

-- Space + s + .
-- 增大当前窗口
map("n", "<leader>s.", function()
  vim.cmd("resize +2")
  vim.cmd("vertical resize +4")
end, {
  desc = "Increase Window Size",
})

-- Space + s + ,
-- 减小当前窗口
map("n", "<leader>s,", function()
  vim.cmd("resize -2")
  vim.cmd("vertical resize -4")
end, {
  desc = "Decrease Window Size",
})

-- =========================================================
-- LSP
-- =========================================================

-- gr：
-- 你的 VS Code：find references
-- LazyVim 默认本来就是这个
map("n", "gr", vim.lsp.buf.references, {
  desc = "References",
})

-- gD
-- VS Code 是 Peek Definition
-- Neovim 没有完全相同的原生 Peek Definition，

-- =========================================================
-- s：EasyMotion 风格跳转
-- =========================================================
--
-- 这里不用再安装 EasyMotion。
-- LazyVim 现在默认的 flash.nvim：
--
--     s
--
-- 就是全屏跳转，使用体验实际上非常接近你的 VS Code EasyMotion。
--
-- 所以不要覆盖 s。
--
-- 你的原配置：
-- s -> <leader><leader>s
--
-- LazyVim：
-- s -> Flash
--
-- 实际使用方式基本一致。

-- =========================================================
-- u -> F
-- =========================================================
--
-- 这是你原 VS Code 配置里非常特殊的一项。
-- 你明确把：
--
--     u -> F
--
-- 所以为了保持一致，这里也覆盖 Vim 默认的 undo。

map("n", "u", "F", {
  desc = "Forward to Character",
})

map("x", "u", "F", {
  desc = "Forward to Character",
})

-- 既然 u 被占用了，留一个显式 undo
map("n", "<leader>u", "u", {
  desc = "Undo",
})

-- =========================================================
-- Leader + s + r
-- 当前文件批量替换
-- =========================================================

map("n", "<leader>sr", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":%s///g<Left><Left><Left>", true, false, true), "n", false)
end, {
  desc = "Search and Replace",
})

-- =========================================================
-- Undo / Redo
-- =========================================================

-- Ctrl+Z → Undo
map("n", "<C-z>", "u", {
  desc = "Undo",
})

-- Ctrl+Shift+Z → Redo
map("n", "<C-S-z>", "<C-r>", {
  desc = "Redo",
})

-- Visual 模式也保持一致
map("x", "<C-z>", "<Esc>u", {
  desc = "Undo",
})

-- map("x", "<C-S-z>", "<Esc><C-r>", {
--   desc = "Redo",
-- })

