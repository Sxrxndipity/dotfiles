-- Autopairs

return function()
    local npairs = require("nvim-autopairs")
    local Rule = require("nvim-autopairs.rule")

    npairs.setup({})

    -- Add < > pairing only for specific filetypes
    npairs.add_rule(
        Rule("<", ">", { "html", "xml", "xhtml", "svg" })
            :with_move(function(opts)
                return opts.next_char == ">"
            end)
            :with_pair(function(_)
                return true
            end)
    )
end
