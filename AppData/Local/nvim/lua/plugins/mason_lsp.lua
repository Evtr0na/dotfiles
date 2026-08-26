return {
    {
        "neovim/nvim-lspconfig",

        event = {
            "BufReadPre",
            "BufNewFile",
        },

        dependencies = {
            ------------------------------------------------------------
            -- Blink
            ------------------------------------------------------------
            -- 确保 Blink 在 LSP 之前加载
            "saghen/blink.cmp",

            ------------------------------------------------------------
            -- Mason
            ------------------------------------------------------------
            {
                "mason-org/mason.nvim",

                build = ":MasonUpdate",

                opts = {
                    ui = {
                        border = "rounded",
                    },
                },
            },

            ------------------------------------------------------------
            -- Mason <-> LSP bridge
            ------------------------------------------------------------
            -- 这里不要写 opts = {}
            -- 我们下面自己 setup，一次就够了
            "mason-org/mason-lspconfig.nvim",
        },

        -- 这尼玛一堆bug
        -- vim.lsp.config("gdshader_lsp", {
        --     cmd = {
        --         "D:/2zhuomian/app/neovim-tool/gdshader-lsp-cpp-master/gdshader_lsp_release_windows.exe",
        --         "--stdio",
        --     },
        --
        --     filetypes = {
        --
        --         "gdshader",
        --         "gdshaderinc",
        --     },
        --     -- nvim-lspconfig 默认只有 project.godot，
        --     -- 这里顺便允许 Git 仓库作为 root。
        --     root_markers = {
        --         "project.godot",
        --         ".git",
        --     },
        -- }),
        --
        -- vim.lsp.enable("gdshader_lsp"),

        config = function()
            ------------------------------------------------------------
            -- lua_ls
            ------------------------------------------------------------
            vim.lsp.config("lua_ls", {
                -- 关闭 lua_ls 的颜色显示
                on_attach = function(client, bufnr)
                    client.server_capabilities.colorProvider = false
                end,

                settings = {
                    Lua = {
                        runtime = {
                            version = "LuaJIT",
                        },

                        diagnostics = {
                            globals = {
                                "vim",
                            },
                        },

                        workspace = {
                            checkThirdParty = false,

                            library = vim.api.nvim_get_runtime_file("", true),
                        },

                        telemetry = {
                            enable = false,
                        },
                    },
                },
            })

            ------------------------------------------------------------
            -- Mason LSP
            ------------------------------------------------------------
            require("mason-lspconfig").setup({
                -- Mason 安装的 LSP 默认自动 enable
                --
                -- 但排除 ast_grep
                automatic_enable = {
                    exclude = {
                        "ast_grep",
                    },
                },
            })
        end,
    },
}
