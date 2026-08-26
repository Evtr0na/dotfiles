--跳转

return {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
        prompt = {
            prefix = { { " > ", "FlashPromptIcon" } }, -- 想要变成空直接改成 { { "", "FlashPromptIcon" } }
        },
        highlight = {
            backdrop = true, -- 启用 FlashBackdrop 高亮组
            matches = false, --让第一个目标字母不高亮
        },
        modes = {
            jump = {
                search = { mode = "search" },
            },
        },
    },
    keys = {
        {
            "s",
            function()
                require("flash").jump()
            end,
            mode = { "n", "v" },
            desc = "Flash Jump",
        },
    },
    config = function(_, opts)
        -- 设置 FlashBackdrop 为灰色，实现"黑白"效果
        vim.api.nvim_set_hl(0, "FlashBackdrop", { fg = "#393939" })
        -- 你也可以在这里设置其他高亮组，例如让标签更醒目
        vim.api.nvim_set_hl(0, "FlashLabel", { fg = "#ff0000", bold = true })
        -- 启用忽略大小写
        vim.o.ignorecase = true
        -- 智能大小写：当搜索模式包含大写字母时，自动切换为大小写敏感
        vim.o.smartcase = true

        -- 然后加载插件
        require("flash").setup(opts)
    end,
}
