return {
    {
        "saghen/blink.cmp",
        event = { "BufReadPost", "BufNewFile" },

        -- 固定使用稳定的 v1
        version = "1.*",

        dependencies = {
            "rafamadriz/friendly-snippets",
        },

        ---@module "blink.cmp"
        ---@type blink.cmp.Config
        opts = {
            ------------------------------------------------------------
            -- 快捷键
            ------------------------------------------------------------
            keymap = {
                -- Enter 接受补全
                preset = "enter",

                -- 保持你原来 nvim-cmp 的操作习惯：
                --
                -- 补全菜单打开时：
                --   Tab     -> 下一项
                --   S-Tab   -> 上一项
                --
                -- snippet 激活时：
                --   Tab     -> 下一个参数
                --   S-Tab   -> 上一个参数
                --
                -- 都没有时：
                --   保持普通 Tab 行为
                ["<Tab>"] = {
                    "select_next",
                    "snippet_forward",
                    "fallback",
                },

                ["<S-Tab>"] = {
                    "select_prev",
                    "snippet_backward",
                    "fallback",
                },
            },

            ------------------------------------------------------------
            -- 外观
            ------------------------------------------------------------
            appearance = {
                nerd_font_variant = "mono",
            },

            ------------------------------------------------------------
            -- 补全
            ------------------------------------------------------------
            completion = {
                -- 类似你原来的 nvim-cmp：
                -- 选中候选时不要直接修改当前代码
                list = {
                    selection = {
                        preselect = true,
                        auto_insert = false,
                    },
                },

                -- 补全菜单
                menu = {
                    border = "rounded",
                },

                -- 文档窗口
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 250,

                    window = {
                        border = "rounded",
                    },
                },
            },

            ------------------------------------------------------------
            -- 补全来源
            ------------------------------------------------------------
            sources = {
                default = {
                    "lsp",
                    "path",
                    "snippets",
                    "buffer",
                },
            },

            ------------------------------------------------------------
            -- Fuzzy matcher
            ------------------------------------------------------------
            fuzzy = {
                -- 优先使用 Blink 的 Rust matcher
                -- Windows 会自动下载对应的预编译版本
                implementation = "prefer_rust_with_warning",
            },
        },

        opts_extend = {
            "sources.default",
        },
    },
}
