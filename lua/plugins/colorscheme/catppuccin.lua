return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup(
      {
        flavour = "macchiato", -- latte, frappe, macchiato, mocha
        background = { -- :h background
          light = "latte",
          dark = "mocha"
        },
        transparent_background = true,
        term_colors = true,
        styles = {
          comments = {
            "italic"
          },
          conditionals = {
            "italic"
          },
          loops = {
            "italic"
          },
          functions = {
            "italic"
          },
          keywords = {
            "italic"
          },
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {}
        },
        color_overrides = {
          mocha = {
            base0A = "#F9E2AF",
            base0B = "#A6E3A1",
            base0C = "#94E2D5",
            base0D = "#89B4FA",
            base0E = "#F5C2E7",
            base0F = "#F2CDCD"
          }
        }
      }
    )
    vim.cmd.colorscheme("catppuccin")
    cmd("color " .. theme)
  end
}
