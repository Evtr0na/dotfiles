local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- 无标题栏，但保留 Windows 原生拖拽缩放
-- config.window_decorations = "RESIZE"

-- 内容完全贴边
config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}

-- 隐藏标签栏
config.enable_tab_bar = false
config.window_decorations = "NONE"

-- 设置与 Neovim 主题一致的背景色（这里以纯黑为例，请换成你 Neovim 的实际背景色）
config.colors = {
    background = "#1E1E2E",
}




return config
