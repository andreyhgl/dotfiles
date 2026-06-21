-- lua/config/plugins.lua
-- Plugin list for lazy.nvim. Syntax highlighting only (no LSP).

return {
    -- Colorscheme with strong Treesitter support (richer highlighting).
    -- priority high + lazy=false so it loads before other UI.
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("tokyonight-moon")
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