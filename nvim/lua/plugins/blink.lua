-- Completion: blink.cmp (pinned to the 1.x line in pack.lua).
-- v1 is self-contained and ships a prebuilt Rust fuzzy binary when on a tag.
-- Snippets are provided by friendly-snippets via the built-in `snippets` source.

return function()
    require("blink.cmp").setup({
        keymap = { preset = "default" },

        appearance = { nerd_font_variant = "mono" },

        completion = {
            documentation = { auto_show = true, auto_show_delay_ms = 200 },
        },

        sources = {
            default = { "lazydev", "lsp", "path", "snippets", "buffer" },
            providers = {
                lazydev = {
                    name = "LazyDev",
                    module = "lazydev.integrations.blink",
                    score_offset = 100,
                },
            },
        },

        -- Uses the Rust matcher when the prebuilt binary is present.
        fuzzy = { implementation = "prefer_rust_with_warning" },

        signature = { enabled = true },
    })
end
