-- Formatting: conform.nvim is the SOLE formatter authority.
-- LSP formatting is only ever a fallback (`lsp_format = "fallback"`).
--
-- The "doesn't break" recipe:
--   * Python -> `ruff_format` (never `ruff check --fix`; that is the lint path)
--   * markdown / text / gitcommit are never formatted
--   * files larger than 200 KB are skipped
--   * formatting is manual by default (`<leader>f`)
--   * escape hatch: `vim.b.disable_autoformat = true`

return function()
    local conform = require("conform")

    local skip_ft = { markdown = true, text = true, gitcommit = true }
    local MAX_SIZE = 200 * 1024

    conform.setup({
        formatters_by_ft = {
            lua = { "stylua" },
            sh = { "shfmt" },
            bash = { "shfmt" },
            zsh = { "shfmt" },
            python = { "ruff_format" },
            html = { "prettier" },
            css = { "prettier" },
            scss = { "prettier" },
            less = { "prettier" },
            javascript = { "prettier" },
            javascriptreact = { "prettier" },
            typescript = { "prettier" },
            typescriptreact = { "prettier" },
            json = { "prettier" },
            jsonc = { "prettier" },
            yaml = { "prettier" },
            -- markdown / text / gitcommit intentionally omitted -> never formatted
        },
        -- Manual formatting only by default. To opt into format-on-save,
        -- replace `false` with the guarded function below.
        format_on_save = false,
        -- format_on_save = function(bufnr)
        --     if vim.b[bufnr].disable_autoformat then return end
        --     if skip_ft[vim.bo[bufnr].filetype] then return end
        --     local name = vim.api.nvim_buf_get_name(bufnr)
        --     if name ~= "" and vim.fn.getfsize(name) > MAX_SIZE then return end
        --     return { timeout_ms = 1000, lsp_format = "fallback" }
        -- end,
        default_format_opts = { lsp_format = "fallback" },
    })

    local function format()
        if vim.b.disable_autoformat then
            vim.notify("Formatting disabled for this buffer", vim.log.levels.INFO)
            return
        end
        if skip_ft[vim.bo.filetype] then
            vim.notify(("Formatting skipped for %s"):format(vim.bo.filetype), vim.log.levels.INFO)
            return
        end
        local name = vim.api.nvim_buf_get_name(0)
        if name ~= "" and vim.fn.getfsize(name) > MAX_SIZE then
            vim.notify("Formatting skipped: file larger than 200 KB", vim.log.levels.INFO)
            return
        end
        conform.format({ async = true, lsp_format = "fallback", timeout_ms = 1000 })
    end

    vim.keymap.set({ "n", "v" }, "<leader>f", format, { desc = "Format buffer" })
end
