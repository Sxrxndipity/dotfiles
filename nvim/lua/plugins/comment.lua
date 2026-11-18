-- Commenting: Comment.nvim

return function()
    require("Comment").setup({
        padding = true,
        mappings = {
            basic = true,
            extra = false,
        },
    })
end
