-- Treesitter: the `main`-branch rewrite (NOT `master`).
-- The old `require('nvim-treesitter.configs').setup{}` API is gone.
-- Requires tree-sitter-cli >= 0.26.1 (install via Mason) + a C compiler.

return function()
    local ts = require("nvim-treesitter")

    ts.setup({
        install_dir = vim.fn.stdpath("data") .. "/site",
    })

    -- Async install; a no-op when the parser is already present.
    -- Core 0.12 bundles parsers/queries for c, lua, vim, vimdoc, query, markdown.
    ts.install({
        "bash",
        "zsh",
        "c",
        "cpp",
        "css",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "scss",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
    })

    -- Highlighting is not enabled automatically on `main`; opt in per filetype.
    -- `pcall` keeps filetypes without a parser (arbitrary config files) quiet.
    vim.api.nvim_create_autocmd("FileType", {
        callback = function()
            pcall(vim.treesitter.start)
        end,
    })
end
