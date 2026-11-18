-- Plugins live in $XDG_DATA_HOME/nvim/site/pack/core/opt
-- Run `:packupdate` / `vim.pack.update()` to sync.

local gh = function(x) return "https://github.com/" .. x end

-- Build/install hooks MUST be registered *before* `vim.pack.add()` so they also
-- fire for installs that happen during the very first `add()` call.
vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind

        -- telescope-fzf-native.nvim is a C sorter: build it after install/update.
        if name == "telescope-fzf-native.nvim" and (kind == "install" or kind == "update") then
            if vim.fn.executable("make") == 1 then
                vim.system({ "make" }, { cwd = ev.data.path }):wait()
            else
                vim.notify(
                    "vim.pack: `make` not found; telescope-fzf-native was not built",
                    vim.log.levels.WARN
                )
            end
        end
    end,
})

vim.pack.add({
    -- colorschemes
    { src = gh("folke/tokyonight.nvim") },
    { src = gh("ellisonleao/gruvbox.nvim") },
    { src = gh("rebelot/kanagawa.nvim") },
    { src = gh("rose-pine/neovim") },
    -- core / deps / ui
    { src = gh("nvim-lua/plenary.nvim") },
    { src = gh("nvim-tree/nvim-web-devicons") },
    { src = gh("nvim-lualine/lualine.nvim") },
    { src = gh("numToStr/Comment.nvim") },
    { src = gh("windwp/nvim-autopairs") },
    { src = gh("nvim-treesitter/nvim-treesitter"), version = "main" },

    -- picker
    { src = gh("nvim-telescope/telescope.nvim") },
    { src = gh("nvim-telescope/telescope-fzf-native.nvim") },

    -- navigation
    { src = gh("ThePrimeagen/harpoon"), version = "harpoon2" },

    -- lsp
    { src = gh("neovim/nvim-lspconfig") },
    { src = gh("mason-org/mason.nvim") },
    { src = gh("mason-org/mason-lspconfig.nvim") },
    { src = gh("folke/lazydev.nvim") },

    -- completion (blink v1 is the stable, self-contained line; it ships a
    -- prebuilt Rust fuzzy binary when installed from a tag).
    { src = gh("saghen/blink.cmp"), version = vim.version.range("1.*") },
    { src = gh("rafamadriz/friendly-snippets") },

    -- formatting / linting
    { src = gh("stevearc/conform.nvim") },
    { src = gh("mfussenegger/nvim-lint") },
    -- misc


},
{
    -- `true` would block on a confirmation prompt for the initial install.
    -- Keep bootstrapping non-interactive.
    confirm = false,
})

-- Each `lua/plugins/<name>.lua` returns a setup function; call it.
-- Ordering: lazydev before blink (blink wires up the lazydev provider),
-- lsp before everything that reads LSP capabilities.
local modules = {
    "tokyonight",
    "rose-pine",
    "kanagawa",
    "gruvbox",
    "lazydev",
    "lsp",
    "conform",
    "lint",
    "blink",
    "treesitter",
    "telescope",
    "harpoon",
    "comment",
    "autopairs",
    "lualine",
}

for _, name in ipairs(modules) do
    local ok, err = pcall(function()
        require("plugins." .. name)()
    end)
    if not ok then
        vim.notify(
            ("plugins.%s failed to load: %s"):format(name, err),
            vim.log.levels.ERROR
        )
    end
end
