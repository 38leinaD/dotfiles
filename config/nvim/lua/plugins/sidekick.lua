return {
    {
        "folke/sidekick.nvim",
        opts = {
            cli = {
                -- Run AI CLI sessions in tmux; also picks up claude/copilot already running in any tmux pane.
                mux = {
                    enabled = true,
                    backend = "tmux",
                    create = "split",
                },
            },
        },
    },
}
