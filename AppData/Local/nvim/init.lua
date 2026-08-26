require("bootstrap") --安装lazy-nvim插件管理

require("config.options") --vim.opt
require("config.keymaps") -- 快捷键
require("config.autocmds") -- 自动命令

require("config.diagnostics") -- 自定义lsp报错
vim.lsp.enable("gdshader_lsp")
require("lazy").setup("plugins") -- 安装插件
