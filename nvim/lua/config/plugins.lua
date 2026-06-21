-- lua/config/plugins.lua
-- Plugin list for lazy.nvim. Syntax highlighting only (no LSP).

return {
    -- Colorscheme: nightfly (dark, strong Treesitter support).
    -- name + lazy=false + high priority so it loads before other UI.
    {
        "bluz71/vim-nightfly-colors",
        name = "nightfly",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme nightfly]])
        end,
    },

    -- Treesitter: syntax highlighting for bash, R, groovy, etc.
    -- Pinned to the `master` branch: nvim-treesitter rewrote itself on `main`
    -- (now the default) with a different, incompatible API. `master` keeps the
    -- classic require("nvim-treesitter.configs").setup{} config working and is
    -- maintained for backward compatibility.
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "master",
        build = ":TSUpdate",
        config = function()
            local ok, configs = pcall(require, "nvim-treesitter.configs")
            if not ok then
                return
            end
            configs.setup({
                ensure_installed = { "bash", "r", "groovy", "lua" },
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    },

    -- Nextflow syntax (filetype + Groovy-based highlighting).
    { "LukeGoodsell/nextflow-vim" },
}