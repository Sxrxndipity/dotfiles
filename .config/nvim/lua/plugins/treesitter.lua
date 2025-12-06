return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local config = require("nvim-treesitter.configs")
      config.setup({
        auto_install = true,
        ensure_installed = {
          "bash",
          "ruby",
          "html",
          "css",
          "scss",
          "javascript",
          "typescript",
          "json",
          "lua",
          "c",
          "python",
          "markdown",
          "markdown_inline",
          "cpp",
        },
        highlight = { enable = true },
        indent = { enable = false },
      })
    end
  }
}
