-- LSP: nvim-lspconfig + mason + mason-lspconfig (v2).
-- Neovim 0.12 sets buffer-local LSP defaults itself (omnifunc, tagfunc,
-- formatexpr, K hover, document colors). Here we only install servers, wire
-- blink capabilities and add per-server settings.

return function()
    -- Completion capabilities come from blink.cmp.
    local capabilities = require("blink.cmp").get_lsp_capabilities()
    vim.lsp.config("*", { capabilities = capabilities })

    -- Python: the ruff LSP is the *only* lint/diagnostics source (never add it
    -- to nvim-lint) and conform's `ruff_format` is the only formatter.
    -- basedpyright adds type-checking diagnostics on top. To make ruff the sole
    -- diagnostics source for Python, disable basedpyright's linter:
    vim.lsp.config("basedpyright", {
        settings = {
            basedpyright = {
                analysis = {
                    -- keep type checking, silence the linter bits ruff already covers
                    diagnosticSeverityOverrides = {},
                    typeCheckingMode = "standard",
                },
            },
        },
    })

    vim.lsp.config("lua_ls", {
        settings = {
            Lua = {
                runtime = { version = "LuaJIT" },
                diagnostics = { globals = { "vim" } },
                workspace = { checkThirdParty = false },
                telemetry = { enable = false },
            },
        },
    })

    vim.lsp.config("emmet_language_server", {
        filetypes = {
            "css", "eruby", "html", "javascript", "javascriptreact",
            "less", "sass", "scss", "pug", "typescriptreact",
        },
        init_options = {
            includeLanguages = {},
            excludeLanguages = {},
            extensionsPath = {},
            preferences = {},
            showAbbreviationSuggestions = true,
            showExpandedAbbreviation = "always",
            showSuggestionsAsSnippets = false,
            syntaxProfiles = {},
            variables = {},
        },
    })

    require("mason").setup()

    -- v2: `automatic_enable` (default true) calls vim.lsp.enable() for every
    -- installed server; `ensure_installed` installs them on first run.
    require("mason-lspconfig").setup({
        ensure_installed = {
            "lua_ls",                 -- config development (+ lazydev)
            "clangd",                 -- C / C++
            "ruff",                   -- Python linter LSP (diagnostics + fixes)
            "basedpyright",           -- Python types
            "ts_ls",                  -- web (JS/TS)
            "emmet_language_server",  -- web
        },
        -- Explicit allowlist: `true` would also auto-enable any other installed
        -- Mason package that happens to have an lspconfig definition. Notably
        -- nvim-lspconfig ships a `stylua --lsp` server, which would re-introduce
        -- a second Lua formatter alongside conform. Keep conform authoritative.
        automatic_enable = {
            "lua_ls",
            "clangd",
            "ruff",
            "basedpyright",
            "ts_ls",
            "emmet_language_server",
        },
    })

    vim.diagnostic.config({
        float = {
            focusable = false,
            style = "minimal",
            border = "rounded",
            source = true,
            header = "",
            prefix = "",
        },
        -- Pop the message box while moving between diagnostics (]d / [d).
        -- `on_jump` replaces the deprecated `jump = { float = true }`.
        jump = {
            on_jump = function(diagnostic, bufnr)
                if not diagnostic then
                    return
                end
                vim.diagnostic.open_float({ bufnr = bufnr, scope = "cursor", focusable = false })
            end,
        },
    })
end
