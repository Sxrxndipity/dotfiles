--   <leader>cp  pick a theme, then a subtheme (live preview while you move)
--   <leader>ct  toggle transparent background (dark themes only, persisted)
--
-- Transparency affects only the editor canvas and gutter: the background, the
-- line numbers, the sign/fold columns and the message area. Floating windows
-- (telescope, diagnostics, hover, completion) are never touched, so they always
-- keep the theme's solid background -- each float draws with its own groups
-- (NormalFloat, FloatBorder, Telescope*Normal, ...), never with the canvas.
--
-- To add a theme: install it in lua/user/pack.lua, add lua/plugins/<name>.lua,
-- then add an entry below. `scheme` is the exact :colorscheme name; the
-- `background` is set first (gruvbox uses one scheme name for dark and light).

local state_dir = vim.fn.stdpath("state")
local scheme_file = state_dir .. "/colorscheme"
local transparent_file = state_dir .. "/colorscheme-transparent"
local augroup = vim.api.nvim_create_augroup("user_colorscheme", {})

local themes = {
    tokyonight = {
        { label = "night", scheme = "tokyonight-night", background = "dark" },
        { label = "storm", scheme = "tokyonight-storm", background = "dark" },
        { label = "moon",  scheme = "tokyonight-moon",  background = "dark" },
        { label = "day",   scheme = "tokyonight-day",   background = "light" },
    },
    gruvbox = {
        { label = "dark",  scheme = "gruvbox", background = "dark" },
        { label = "light", scheme = "gruvbox", background = "light" },
    },
    kanagawa = {
        { label = "wave",   scheme = "kanagawa-wave",   background = "dark" },
        { label = "dragon", scheme = "kanagawa-dragon", background = "dark" },
        { label = "lotus",  scheme = "kanagawa-lotus",  background = "light" },
    },
    ["rose-pine"] = {
        -- NB: main is rose-pine-main, not bare rose-pine -- the plugin remembers
        -- the last variant, so bare rose-pine keeps rendering moon/dawn.
        { label = "main", scheme = "rose-pine-main", background = "dark" },
        { label = "moon", scheme = "rose-pine-moon", background = "dark" },
        { label = "dawn", scheme = "rose-pine-dawn", background = "light" },
    },
}

local last_variant       -- exact variant last applied
local previewing = false -- true while the subtheme picker is open

-- State ----------------------------------------------------------------

-- Find a variant by scheme (and background, to tell gruvbox dark from light).
local function find_variant(scheme, background)
    local fallback
    for _, variants in pairs(themes) do
        for _, v in ipairs(variants) do
            if v.scheme == scheme then
                if background == nil or v.background == background then
                    return v
                end
                fallback = fallback or v
            end
        end
    end
    return fallback
end

-- State: two lines (scheme, background) + a flag file for transparency.
local function read_saved()
    if vim.fn.filereadable(scheme_file) == 1 then
        local lines = vim.fn.readfile(scheme_file)
        if lines[1] and lines[1] ~= "" then
            return find_variant(lines[1], lines[2])
        end
    end
end

local function write_saved(v)
    if v then
        vim.fn.writefile({ v.scheme, v.background }, scheme_file)
    end
end

local function transparent_enabled()
    return vim.fn.filereadable(transparent_file) == 1
end

-- Highlights ------------------------------------------------------------

-- Resolved attributes of a group, following links.
local function resolved(hl)
    local attrs = vim.api.nvim_get_hl(0, { name = hl })
    local depth = 0
    while attrs.link and depth < 10 do
        attrs = vim.api.nvim_get_hl(0, { name = attrs.link })
        depth = depth + 1
    end
    attrs.link = nil
    return attrs
end

local function bg_of(hl)
    return resolved(hl).bg
end

-- Set just the background of a group, keeping the fg/attrs it resolves to.
local function set_bg(hl, bg)
    local attrs = resolved(hl)
    attrs.bg = bg
    vim.api.nvim_set_hl(0, hl, attrs)
end

-- The editor canvas and gutter: only these lose their background in
-- transparent mode. The diagnostic sign groups are included because themes
-- paint the sign column through them (gruvbox links DiagnosticSignError to a
-- GruvboxRedSign that carries the SignColumn background).
local CANVAS = {
    "Normal", "NormalNC", "MsgArea",
    "NonText", "EndOfBuffer", "SignColumn", "FoldColumn", "LineNr", "CursorLineNr",
    "DiagnosticSignError", "DiagnosticSignWarn", "DiagnosticSignInfo", "DiagnosticSignHint",
}

-- Floats, menus and telescope must always stay solid, so these are never
-- stripped. Themes start with `hi clear`, so a group the theme does not
-- redefine comes back undefined -- and since telescope maps its windows to
-- these groups, an undefined one renders see-through. We give any missing
-- group the theme's solid background.
local SOLID = {
    "NormalFloat", "FloatBorder", "FloatTitle", "Pmenu",
    "TelescopeNormal", "TelescopeBorder",
    "TelescopePromptNormal", "TelescopePromptBorder",
    "TelescopeResultsNormal", "TelescopeResultsBorder",
    "TelescopePreviewNormal", "TelescopePreviewBorder",
}

-- Last Normal attributes that had a real background, so the canvas can be
-- restored even if a theme does not reset a group we stripped.
local solid_normal

local function refresh()
    local normal = resolved("Normal")
    if type(normal.bg) == "number" then
        solid_normal = normal
    end
    local normal_bg = (solid_normal or normal).bg

    local dark
    if type(normal_bg) == "number" then
        local r = math.floor(normal_bg / 0x10000) % 0x100
        local g = math.floor(normal_bg / 0x100) % 0x100
        local b = normal_bg % 0x100
        dark = (0.299 * r + 0.587 * g + 0.114 * b) < 128 -- ITU-R BT.601 luma
    else
        dark = vim.o.background ~= "light"
    end

    if transparent_enabled() and dark then
        for _, hl in ipairs(CANVAS) do
            set_bg(hl, "none")
        end
    else
        for _, hl in ipairs(CANVAS) do
            if bg_of(hl) == nil and solid_normal then
                set_bg(hl, solid_normal.bg)
            end
        end
    end

    if solid_normal then
        for _, hl in ipairs(SOLID) do
            if bg_of(hl) == nil then
                vim.api.nvim_set_hl(0, hl, { fg = solid_normal.fg, bg = solid_normal.bg })
            end
        end
    end
end

vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
    group = augroup,
    callback = function()
        refresh()
        pcall(function() require("lualine").refresh() end)
    end,
})

-- Apply ----------------------------------------------------------------

local function apply_variant(variant)
    last_variant = variant
    vim.o.background = variant.background
    if not pcall(vim.cmd.colorscheme, variant.scheme) then
        vim.notify(("colorscheme %q failed to load"):format(variant.scheme), vim.log.levels.WARN)
    end
    if not previewing then -- remember the pick, but not preview movements
        write_saved(variant)
    end
end

local function toggle_transparency()
    local on = not transparent_enabled()
    if on then
        vim.fn.writefile({}, transparent_file)
    else
        vim.fn.delete(transparent_file)
    end
    if last_variant then
        apply_variant(last_variant)
    end

    if on and not (last_variant and last_variant.background == "dark") then
        vim.notify("Transparent background: on (dark themes only)", vim.log.levels.INFO)
    else
        vim.notify("Transparent background: " .. (on and "on" or "off"), vim.log.levels.INFO)
    end
end

-- Picker ----------------------------------------------------------------

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local tconf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local function pick_variant(theme)
    local variants = themes[theme]
    local before = last_variant

    local default = 1
    for i, v in ipairs(variants) do
        if v == before then
            default = i
        end
    end

    local confirmed = false
    local picker = pickers.new({}, {
        prompt_title = "Colorscheme: " .. theme,
        finder = finders.new_table({
            results = variants,
            entry_maker = function(v)
                return { value = v, display = v.label, ordinal = v.label }
            end,
        }),
        sorter = tconf.generic_sorter({}),
        default_selection_index = default,
        attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
                local sel = action_state.get_selected_entry()
                confirmed, previewing = true, false
                actions.close(prompt_bufnr)
                if sel then
                    apply_variant(sel.value)
                end
            end)
            return true
        end,
    })

    -- Live preview as the selection moves.
    local set_selection = picker.set_selection
    picker.set_selection = function(self, row)
        set_selection(self, row)
        local sel = action_state.get_selected_entry()
        if sel then
            apply_variant(sel.value)
        end
    end

    -- Closing without confirming restores the scheme from before the picker.
    local close_windows = picker.close_windows
    picker.close_windows = function(status)
        close_windows(status)
        previewing = false
        if not confirmed and before then
            apply_variant(before)
        end
    end

    previewing = true
    picker:find()
end

local function pick()
    local names = vim.tbl_keys(themes)
    table.sort(names)

    pickers.new({}, {
        prompt_title = "Colorschemes",
        finder = finders.new_table({ results = names }),
        sorter = tconf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
                local theme = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                if theme then
                    pick_variant(theme.value)
                end
            end)
            return true
        end,
    }):find()
end

-- Startup ---------------------------------------------------------------

local saved = read_saved()
if saved then
    apply_variant(saved)
else
    refresh()
end

vim.keymap.set("n", "<leader>cp", pick, { desc = "Colorscheme" })
vim.keymap.set("n", "<leader>ct", toggle_transparency, { desc = "Toggle transparent background" })

return {
    pick = pick,
    themes = themes,
    toggle_transparency = toggle_transparency,
    apply = function(scheme, background)
        local v = find_variant(scheme, background)
        if v then
            apply_variant(v)
        end
    end,
}
