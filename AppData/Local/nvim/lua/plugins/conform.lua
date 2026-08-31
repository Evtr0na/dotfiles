--a formatting tool

return {

    "stevearc/conform.nvim",

    -- 让 gdshader-nvim-support 先加载，以便它自动注册
    -- `gdshader` formatter（见其 format.lua）。
    dependencies = {},

    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
        formatters_by_ft = {
            -- 为 lua 文件指定格式化工具为 stylua
            lua = { "stylua" },
            gdscript = { "gdscript‑formatter" },
            -- GDShader：由 gdshader-nvim-support 自动注册 formatter
            gdshader = { "gdshader" },
            gdshaderinc = { "gdshader" },
        },
        -- 保存文件时自动格式化（如果不需要自动格式化，可直接删掉 format_on_save）
        format_on_save = {
            timeout_ms = 500,
            lsp_fallback = true,
        },
        formatters = {
            ["gdscript‑formatter"] = {
                command = "gdscript-formatter",
                args = { "--safe" }, --安全模式，防止格式化意外改变代码逻辑
                stdin = true,
            },
        },
    },
}
