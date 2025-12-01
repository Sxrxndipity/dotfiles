return {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    config = function()
        require("rose-pine").setup({
            transparent = true,
            styles = {
                transparency = true,
                sidebars = "transparent",
                floats = "transparent",
            },
        })
        vim.cmd("colorscheme rose-pine")
    end,
}
