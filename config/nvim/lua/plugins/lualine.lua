return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    -- Forcefully redefine the right side of the statusline
    opts.sections.lualine_z = { }
  end,
}

