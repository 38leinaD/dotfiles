return {
    {
        "neovim/nvim-lspconfig",
        cond = function()
            return vim.env.DISABLE_JDTLS ~= "1"
        end
    },
}
