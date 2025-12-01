return {
  'norcalli/nvim-colorizer.lua',
  -- 1. Modify the 'ft' (filetypes) list to include toml and conf,
  -- but we will rely more on the config function below.
  -- Let's remove 'ft' and use the main config for simplicity and reliability.
  -- ft = { ... },

  -- Load immediately so it can process configurations early
  lazy = false,

  config = function()
    require('colorizer').setup({
      -- We will use the 'filetypes' table to specify which buffers to attach to.
      filetypes = {
        '*', -- **REQUIRED** to highlight any file not explicitly listed below.
             -- This catches all files, including generic '.conf' files.
        'toml', -- Explicitly attach to TOML files
        'conf', -- Explicitly attach to CONF files (if Neovim assigns this filetype)
        'lua', 'css', 'html', 'javascript', 'typescript', -- Add back your core languages
      },

      -- Global options for all filetypes
      user_default_options = {
        mode = 'background', -- Crucial for 256-color fallback
        names = false,       -- Disable color names for performance
        RGB = true,
        RRGGBB = true,
        -- Add any other formats you expect to see in config files (e.g., RGB functions)
        rgb_fn = false,
        hsl_fn = false,
      },
    })
  end,
}

