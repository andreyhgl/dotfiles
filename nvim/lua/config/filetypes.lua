-- lua/config/filetypes.lua
-- .nf scripts and nextflow.config), loaded from init.lua.

vim.filetype.add({
    extension = {
        nf = "nextflow",
    },
    filename = {
        ["nextflow.config"] = "nextflow",
    },
})
