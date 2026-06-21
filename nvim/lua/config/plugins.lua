-- lua/config/plugins.lua
-- Plugin list for lazy.nvim. Syntax highlighting only (no LSP).

return {
    -- Treesitter: modern syntax highlighting + indentation for bash, R, etc.
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "bash", "r", "groovy", "lua" },
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    },

    -- Nextflow syntax (filetype + Groovy-based highlighting).
    -- Treesitter's groovy parser handles much of it; this adds Nextflow-aware
    -- highlighting for .nf files specifically.
    { "LukeGoodsell/nextflow-vim" },
}
