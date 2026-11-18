-- lazydev: configures LuaLS for editing *this* config.
-- Successor to neodev; Neovim's own API types ship with core since 0.10, so
-- lazydev only supplies third-party/luvit/plugin libraries.
-- The blink provider is declared in lua/plugins/blink.lua.

return function()
    require("lazydev").setup({
        library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
        integrations = { lspconfig = true },
    })
end
