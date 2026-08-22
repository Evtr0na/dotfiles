--模糊搜索，



return {
  "nvim-telescope/telescope.nvim",

  dependencies = {
    "nvim-lua/plenary.nvim",

    -- fzf 原生排序器（已手动构建，此处保留 build 以便日后更新）
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = function()
        if vim.fn.has("win32") == 1 then
          return "mingw32-make"
        else
          return "make"
        end
      end,
    },

    -- zoxide 智能目录跳转
    "jvgrootveld/telescope-zoxide",
  },

  opts = {
    defaults = {
      path_display = { "smart" },
      vimgrep_arguments = {
        "rg",
        "--follow",
        "--hidden",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
      },
      find_command = vim.fn.executable("fd") == 1
        and { "fd", "--type", "f", "--hidden", "--follow" }
        or nil,
    },

    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      },
      zoxide = {
        prompt_title = "[ Zoxide ]",
        score = true,
      },
    },
  },

  config = function(_, opts)
    require("telescope").setup(opts)

    -- 直接加载 fzf 扩展（无需检查 fzf 命令，因为扩展本身不依赖它）
    require("telescope").load_extension("fzf")

    -- 加载 zoxide 扩展
    require("telescope").load_extension("zoxide")

    -- ⚠️ 快捷键已移除（按你的要求，不配置）
    -- 如果你以后想添加，可以在这里自行添加 vim.keymap.set(...)
  end,
}
