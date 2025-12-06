return {
  -- 1. Plugin Download via lazy.nvim
  "mfussenegger/nvim-lint",
  lazy = true,
  event = {
    "BufReadPre",
    "BufNewFile",
  },
  config = function()
    local lint = require("lint")

    -- 2. Define Linters by Filetype
    lint.linters_by_ft = {
      -- Python Files: Uses Ruff
      -- Note: 'ruff' is a built-in linter in nvim-lint
      python = { "ruff" },

      -- JavaScript/TypeScript Files: Uses eslint_d
      -- nvim-lint recommends 'eslint_d' for performance
      -- javascript = { "eslint_d" },
      -- typescript = { "eslint_d" },
      -- javascriptreact = { "eslint_d" },
      -- typescriptreact = { "eslint_d" },

      -- Makefiles: Uses checkmake
      -- Note: 'checkmake' must be installed on your system
      make = { "checkmake" },
    }

    -- 3. Autocommand to Run Linting
    -- This sets up automatic linting whenever you save a file
    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      callback = function()
        -- Ensure linting only runs if the buffer is a file (not a prompt or scratch buffer)
        if vim.bo.buftype == "" then
          lint.try_lint()
        end
      end,
    })

    -- Optional: Autocommand to clear signs/diagnostics when leaving a buffer
    -- vim.api.nvim_create_autocmd({ "BufReadPost" }, {
    --     callback = function()
    --         vim.diagnostic.disable(0)
    --     end
    -- })

    -- Optional: Command to run linting manually
    vim.api.nvim_create_user_command("Lint", function()
      lint.try_lint()
    end, {})
  end,
}
