return {
  {
    "loctvl842/monokai-pro.nvim",
    opts = {
      filter = "pro", -- classic, octagon, pro, machine, ristretto, spectrum
      styles = {
        comment = { italic = false },
        keyword = { italic = false },
        type = { italic = false },
        storageclass = { italic = false },
        structure = { italic = false },
        parameter = { italic = false },
        annotation = { italic = false },
        tag_attribute = { italic = false },
      },
    },
  },
  {
    "ring0-rootkit/ring0-dark.nvim",
  },
  {
    "EdenEast/nightfox.nvim",
    opts = {
      options = {
        styles = {
          comments = "NONE",
          conditionals = "NONE",
          constants = "NONE",
          functions = "NONE",
          keywords = "NONE",
          numbers = "NONE",
          operators = "NONE",
          strings = "NONE",
          types = "NONE",
          variables = "NONE",
        },
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
        --colorscheme = "monokai-pro"
        --colorscheme = "ring0dark"
        colorscheme = "monokai-pro",
        --colorscheme = "carbonfox",
    }
  }
}
