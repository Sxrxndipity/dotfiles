return {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    -- Remove the 'opts = {}' unless you plan to use it later,
    -- and ensure the setup call is inside the 'config' function.

    config = function()
        require('tokyonight').setup({
            transparent = true,
            terminal_colors = true,
            styles = {
                sidebars = "transparent",
                floats = "transparent",
            },
        })

        -- After setting up the theme, ensure it's applied
        -- This line is often necessary when setting up a colorscheme outside of init.lua
        vim.cmd("colorscheme tokyonight")
    end
}
