require("user.pack")
require("user.remap")
require("user.colorscheme")
require("user.set")

-- Native undotree (ships as a "dist" opt plugin in 0.12: :packadd nvim.undotree)
vim.cmd.packadd("nvim.undotree")

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local userGroup = augroup("user", { clear = true })
local yank_group = augroup("HighlightYank", { clear = true })

-- Reload helper (plenary)
function R(name)
    require("plenary.reload").reload_module(name)
end


autocmd("TextYankPost", {
    group = yank_group,
    pattern = "*",
    callback = function()
        vim.hl.on_yank({
            higroup = "IncSearch",
            timeout = 40,
        })
    end,
})

-- Trim trailing whitespace on save
autocmd( "BufWritePre" , {
    group = userGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

-- telescope
local builtin = require 'telescope.builtin'

-- Add Telescope-based LSP pickers when an LSP attaches to a buffer.
-- If you later switch picker plugins, this is where to update these mappings.
autocmd('LspAttach', {
    group = userGroup,
    callback = function(event)
        local buf = event.buf

        -- Find references for the word under your cursor.
        vim.keymap.set('n', 'grr', builtin.lsp_references, { buffer = buf, desc = '[G]oto [R]eferences' })

        -- Jump to the implementation of the word under your cursor.
        -- Useful when your language has ways of declaring types without an actual implementation.
        vim.keymap.set('n', 'gri', builtin.lsp_implementations, { buffer = buf, desc = '[G]oto [I]mplementation' })

        -- Jump to the definition of the word under your cursor.
        -- This is where a variable was first declared, or where a function is defined, etc.
        -- To jump back, press <C-t>.
        vim.keymap.set('n', 'grd', builtin.lsp_definitions, { buffer = buf, desc = '[G]oto [D]efinition' })

        -- Fuzzy find all the symbols in your current document.
        -- Symbols are things like variables, functions, types, etc.
        vim.keymap.set('n', 'gO', builtin.lsp_document_symbols, { buffer = buf, desc = 'Open Document Symbols' })

        -- Fuzzy find all the symbols in your current workspace.
        -- Similar to document symbols, except searches over your entire project.
        vim.keymap.set('n', 'gW', builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = 'Open Workspace Symbols' })

        -- Jump to the type of the word under your cursor.
        -- Useful when you're not sure what type a variable is and you want to see
        -- the definition of its *type*, not where it was *defined*.
        vim.keymap.set('n', 'grt', builtin.lsp_type_definitions, { buffer = buf, desc = '[G]oto [T]ype Definition' })
    end,
})



-- Native documentColor (replaces norcalli/nvim-colorizer.lua).
-- ON by default in 0.12; server-driven (cssls/scss/less/tailwind).
-- vim.keymap.set("n", "<leader>dc", function()
--     vim.lsp.document_color.enable(not vim.lsp.document_color.is_enabled())
-- end, { desc = "Toggle document colors" })

