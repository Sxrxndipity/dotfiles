return function ()
    require("tokyonight").setup({
        on_colors = function () end,
        on_highlights = function () end,
        terminal_colors = true,
        transparent = true,
        styles = {
            sidebars = "transparent",
        }
    })
    -- vim.cmd[[colorscheme tokyonight]]
end
