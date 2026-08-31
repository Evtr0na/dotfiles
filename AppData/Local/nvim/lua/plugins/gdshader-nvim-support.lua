return {
    dir = "D:/2zhuomian/app/source/gdshader-nvim-support",
    -- "Evtr0na/gdshader-nvim-support",

    ft = { "gdshader", "gdshaderinc" },
    config = function()
        require("gdshader_nvim").setup({
            color = {
                decorate = true,
                editor = "ccc",
                -- swath = "● ",
                swatch_pad_left = 0, -- 方块前 9 个空格
                swatch_pad_right = 1, -- 方块后 8 个空格
            },
        })
    end,
}
