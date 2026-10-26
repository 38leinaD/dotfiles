-- jdtls is not started automatically for java files. Run :JdtlsStart to load
-- nvim-jdtls; it then starts jdtls for the project and attaches to every java
-- buffer, including the ones opened afterwards.
vim.api.nvim_create_user_command("JdtlsStart", function()
    local plugin = require("lazy.core.config").plugins["nvim-jdtls"]
    if plugin._.loaded then
        vim.notify("jdtls already enabled", vim.log.levels.INFO)
        return
    end
    -- Provides vim.lsp.config.jdtls, which is not loaded yet when no file is open.
    require("lazy").load({ plugins = { "nvim-lspconfig" } })

    -- nvim-jdtls only starts for a buffer backed by a file and uses it to find the
    -- project root. Without a java buffer, use the project's root marker file
    -- (pom.xml, build.gradle, .git, ...) found upwards from the cwd.
    local anchor = vim.api.nvim_get_current_buf()
    if vim.bo[anchor].filetype ~= "java" then
        -- root_markers is a list of marker groups in priority order.
        local marker
        for _, group in ipairs(vim.lsp.config.jdtls.root_markers) do
            marker = marker or vim.fs.find(group, { upward = true, path = vim.fn.getcwd() })[1]
        end
        if not marker then
            vim.notify("No java project found from " .. vim.fn.getcwd(), vim.log.levels.ERROR)
            return
        end
        anchor = vim.fn.bufadd(marker)
        vim.bo[anchor].buflisted = false
        vim.fn.bufload(anchor)
    end

    -- The LazyVim config attaches the current buffer on load.
    vim.api.nvim_buf_call(anchor, function()
        require("lazy").load({ plugins = { "nvim-jdtls" } })
    end)

    -- Attach the other open java buffers.
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if buf ~= anchor and vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype == "java" then
            vim.api.nvim_exec_autocmds("FileType", { buffer = buf, pattern = "java" })
        end
    end
end, { desc = "Start jdtls (java LSP)" })

return {
    {
        "mfussenegger/nvim-jdtls",
        -- Drop the ft = "java" trigger from the LazyVim java extra.
        ft = function()
            return {}
        end,
    },
}
