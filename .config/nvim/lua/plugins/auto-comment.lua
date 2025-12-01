return {
  'numToStr/Comment.nvim',
  lazy = false, -- Load on startup for quick use
  opts = {
    -- Optional: Set the leader key to something other than the default 'g'
    -- You can remove the opts table if you're happy with the defaults
    padding = true,
    mappings = {
        -- Set to false to use default gC and gc mapping
        basic = true,
        -- LHS of operator-pending mapping in visual and normal mode
        extra = false,
    },
  }
}
