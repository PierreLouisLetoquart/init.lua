return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")

    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
      }
    })

    -- enable mason lpconfig
    mason_lspconfig.setup({
      -- list of the server for mason to install
      ensure_installed = {
        -- cpp
        "clangd",
        "cmake",
        -- basics
        "lua_ls",
        "marksman",
        -- rust
        "rust_analyzer",
        -- front
        "cssls",
        "html",
        "jsonls",
        "tsserver",
        "tailwindcss",
      },

      -- automatically install the server if not found
      automatic_installation = false,
    })
  end,
}
