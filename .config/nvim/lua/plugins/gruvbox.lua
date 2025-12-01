return {
    "ellisonleao/gruvbox.nvim",
    lazy = false, -- Ensure it loads before themery tries to switch to it
    priority = 1000,
    config = function()
        require('gruvbox').setup({
            transparent_mode = true,
            terminal_colors = true,
            overrides = {},
            vim.cmd("colorscheme gruvbox")
        })
    end,
}
