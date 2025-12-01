return {
  'windwp/nvim-autopairs',
  event = "InsertEnter", -- Load only when entering insert mode for efficiency
  config = function()
    require('nvim-autopairs').setup({})
  end,
}
