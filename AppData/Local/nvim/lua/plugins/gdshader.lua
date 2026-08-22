
--只能补全gdshader代码
return {
  "Evtr0na/gdshader_neovim_support",
  ft = { "gdshader", "gdshaderinc" },
  dependencies = {
    "hrsh7th/nvim-cmp",  -- 代码补全引擎
  },
  config = function()
    -- 启用代码补全
    require("gdshader_neovim_support").setup()
  end,
}






