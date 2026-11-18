-- Picker: telescope + the fzf-native C sorter.
-- fzf-native is built by the PackChanged hook in lua/user/pack.lua.
-- Backends: `find_files` prefers `rg --files`; `live_grep` REQUIRES ripgrep.

return function()
    local telescope = require("telescope")
    telescope.setup({})
    pcall(telescope.load_extension, "fzf")
end
