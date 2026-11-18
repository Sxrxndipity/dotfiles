vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- vim.api.nvim_set_keymap("n", "<leader>tf", "<Plug>PlenaryTestFile", { noremap = false, silent = false })

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "=ap", "ma=ap'a")
-- Neovim 0.12 provides `:lsp restart`; nvim-lspconfig v2 no longer defines
-- `:LspRestart` when the built-in `:lsp` command is available.
vim.keymap.set("n", "<leader>lr", "<cmd>lsp restart<cr>")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", "\"_d")

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")


vim.keymap.set("n", "<C-a>", "ggVG")


-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
-- vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
-- vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })


vim.keymap.set("n", "<leader><leader>", "<cmd>source %<CR>")
vim.keymap.set("n", "<leader><leader>x", ":.lua<CR>")

-- Neovim 0.12 deprecates vim.diagnostic.goto_prev()/goto_next() in favour of
-- vim.diagnostic.jump().
vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1 }) end, { desc = 'Previous diagnostic' })
vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1 }) end, { desc = 'Next diagnostic' })

-- themery is deferred/dropped for now -> mapping disabled.
-- vim.keymap.set('n', "<leader>tt", "<cmd>Themery<CR>")

vim.keymap.set('n', "<leader>o", "<cmd>lua vim.ui.open(vim.fn.expand('%'))<CR>")
-- Toggle wrap
vim.keymap.set("n", "<C-w>", function()
  vim.wo.wrap = not vim.wo.wrap
end, { desc = "Toggle line wrap" })

-- Harpoon
local harpoon = require("harpoon")
vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "Harpoon add file" })
vim.keymap.set("n", "<C-h>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon menu" })

vim.keymap.set("n", "<C-j>", function() harpoon:list():select(1) end, { desc = "Harpoon 1" })
vim.keymap.set("n", "<C-k>", function() harpoon:list():select(2) end, { desc = "Harpoon 2" })
vim.keymap.set("n", "<C-l>", function() harpoon:list():select(3) end, { desc = "Harpoon 3" })
vim.keymap.set("n", "<C-;>", function() harpoon:list():select(4) end, { desc = "Harpoon 4" })

-- Telescope
local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set({ 'n', 'v' }, '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set('n', '<leader>sc', builtin.commands, { desc = '[S]earch [C]ommands' })
-- vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

-- Terminal
local term_buf = nil
local previous_buf = nil
local terminal_visible = false

local function toggle_terminal()
    local win = vim.api.nvim_get_current_win()

    if terminal_visible then
        vim.api.nvim_win_set_buf(win, previous_buf)
        terminal_visible = false
        return
    end

    previous_buf = vim.api.nvim_win_get_buf(win)

    if not term_buf or not vim.api.nvim_buf_is_valid(term_buf) then
        vim.cmd("enew")
        vim.cmd("term")
        term_buf = vim.api.nvim_get_current_buf()
    else
        vim.api.nvim_win_set_buf(win, term_buf)
    end

    terminal_visible = true
    vim.cmd("startinsert")
end

vim.keymap.set("n", "<leader>t", toggle_terminal, {
    desc = "Toggle terminal",
})
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', {desc = 'Exit Terminal Mode'})

