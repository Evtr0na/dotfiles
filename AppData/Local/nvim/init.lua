require("bootstrap") --安装lazy-nvim插件管理

require("config.options") --vim.opt
require("config.keymaps") -- 快捷键
require("config.autocmds") -- 自动命令

require("lsp.LSP_Virtual_Text") -- 自定义lsp报错

require("lazy").setup("plugins") -- 安装插件
