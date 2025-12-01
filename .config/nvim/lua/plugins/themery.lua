return {
    "zaldih/themery.nvim",
    lazy = false,
    config = function()
        require("themery").setup({
            themes = {"gruvbox", "tokyonight-night","tokyonight-storm","tokyonight-day",
            "tokyonight-moon","rose-pine-main","rose-pine-moon","rose-pine-dawn","kanagawa-wave","kanagawa-dragon","kanagawa-lotus"}, -- Your list of installed colorschemes.
            livePreview = true, -- Apply theme while picking. Default to true.
        })
    end
}
