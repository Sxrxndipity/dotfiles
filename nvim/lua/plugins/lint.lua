-- Linters for filetypes that have NO language server (see lua/plugins/lsp.lua).
--
-- Deliberately slim: `ruff` is NOT here because the ruff LSP is the single
-- Python diagnostics source (duplicating it caused the old double-diagnostics).
-- Formatting is a separate, sole authority in lua/plugins/conform.lua.
--
-- Requires the CLI to be on PATH (Mason): shellcheck.

return function()
    -- require("lint").linters_by_ft = {
    --     sh = { "shellcheck" },
    --     bash = { "shellcheck" },
    --     zsh = { "shellcheck" },
    --     make = { "checkmake" },
    -- }

    -- Lint once the filetype is known (i.e. on open) and after each write.
    -- NOTE: use FileType, not BufReadPost -- at BufReadPost `filetype` is still
    -- empty, so linters_by_ft wouldn't match and nothing would run.
    vim.api.nvim_create_autocmd({ "FileType", "BufWritePost" }, {
        callback = function()
            require("lint").try_lint()
        end,
    })
end
