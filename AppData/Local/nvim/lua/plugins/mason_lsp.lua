return {
  -- Mason本体
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    opts = {
      ui = { border = "rounded" },
    },
  },

  -- mason‑lspconfig 桥接
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim" },
    opts = {},
  },

  -- nvim‑lspconfig + 全自动LSP启动
  {
    "neovim/nvim-lspconfig",
    config = function()
      local mason_lspconfig = require("mason-lspconfig")
      mason_lspconfig.setup()

      -- 👉 黑名单：不想自动启动的LSP放这里
      local blacklist = {
        ast_grep = true,
      }

      -- 👉 自定义配置注册表：只有需要特殊参数的LSP才放这里
      local custom_settings = {
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = { globals = { "vim" } },
              workspace = {
                checkThirdParty = false,
                library = vim.api.nvim_get_runtime_file("", true),
              },
              telemetry = { enable = false },
            },
          },
        },
      }

      -- 全自动循环启用所有已经安装好、不在黑名单内的LSP
      for _, server_name in ipairs(mason_lspconfig.get_installed_servers()) do
        if not blacklist[server_name] then
          local opts = custom_settings[server_name] or {}
          vim.lsp.config(server_name, opts)
          vim.lsp.enable(server_name)
        end
      end
    end,
  },
}
