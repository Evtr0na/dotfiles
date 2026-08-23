--godotscript的lsp
return {
    {
        "Mathijs-Bakker/godotdev.nvim",
        ft = { "gd", "gdshader", "gdscript" },
        dependencies = {
            "mfussenegger/nvim-dap",
            "rcarriga/nvim-dap-ui",
            "nvim-treesitter/nvim-treesitter",
        },
        opts = { sence_tree = {
            buffer = {
                position = "left",
                size = "0.35",
            },
        } },

        config = function()
            require("godotdev").setup({
                editor_host = "127.0.0.1",
                editor_port = 6005,
                godot_path = "D:\\2zhuomian\\Projects\\GameDev\\Engines\\4.7.1-stable\\Godot471.exe",

                csharp = false,
                autostart_editor_server = false,
                formatter = false,

                inline_hints = {
                    enabled = false,
                },
            })

            vim.lsp.config("gdscript", {
                filetypes = {
                    "gdscript",
                },
            })

            vim.lsp.enable("gdscript")
        end,
    },
}
