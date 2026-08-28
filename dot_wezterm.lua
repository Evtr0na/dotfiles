local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- 字体配置
config.font = wezterm.font({
	family = "Iosevka",
	-- weight = "Regular",
	-- weight = "Medium",
	-- weight = "Bold",
	style = "Normal",
	harfbuzz_features = { "calt=0", "liga=0", "clig=0" },
})

-- config.font_rules = {
-- 	{
-- 		intensity = "Bold",
-- 		italic = false,
-- 		font = wezterm.font({
-- 			family = "Iosevka",
-- 			weight = "Bold",
-- 			harfbuzz_features = {
-- 				"calt=0",
-- 				"liga=0",
-- 				"clig=0",
-- 			},
-- 		}),
-- 	},
-- }

config.font_size = 14.0

-- 先显式保持默认比例
config.line_height = 1.0
config.cell_width = 1.0

-- Windows字体渲染优化，改善Iosevka发虚
-- config.freetype_load_target = "Normal"
config.freetype_load_target = "Mono"
config.freetype_render_target = "HorizontalLcd"

-- 无标题栏，但保留 Windows 原生拖拽缩放
config.window_decorations = "RESIZE"

-- 内容完全贴边
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- 隐藏标签栏
config.enable_tab_bar = true
-- config.window_decorations = "NONE"

-- 设置与 Neovim 主题一致的背景色（这里以纯黑为例，请换成你 Neovim 的实际背景色）
config.colors = {
	-- cursor_fg = '#6c6c6c',     -- 光标前景色（光标覆盖在文字上时，文字显示的颜色）
	cursor_bg = "#CDD6F4", -- 光标背景色（即光标自身的颜色，如鲜红色）
	-- cursor_border = '#ff5555', -- 光标边框颜色（可选）
	background = "#181818",
	-- foreground = "#e4e4e4",
	foreground = "#e4e4ef",
}

return config
