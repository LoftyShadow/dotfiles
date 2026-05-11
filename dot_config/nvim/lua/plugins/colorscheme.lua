return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      transparent_background = true,
      integrations = {
        telescope = true,
        which_key = true,
        snacks = true,
      },
    },
    specs = {
      {
        "akinsho/bufferline.nvim",
        optional = true,
        opts = function(_, opts)
          if not (vim.g.colors_name or ""):find("catppuccin") then
            return
          end

          local colors = require("catppuccin.palettes").get_palette("frappe")
          opts.highlights = require("catppuccin.special.bufferline").get_theme({
            custom = {
              frappe = {
                buffer_selected = { fg = colors.crust, bg = colors.blue, style = { "bold" } },
                numbers_selected = { fg = colors.crust, bg = colors.blue, style = { "bold" } },
                close_button_selected = { fg = colors.crust, bg = colors.blue },
                indicator_selected = { fg = colors.peach, bg = colors.blue, style = { "bold" } },
                modified_selected = { fg = colors.crust, bg = colors.blue, style = { "bold" } },
                separator_selected = { fg = colors.blue, bg = colors.blue },
                duplicate_selected = { fg = colors.crust, bg = colors.blue, style = { "bold" } },
                diagnostic_selected = { fg = colors.crust, bg = colors.blue, style = { "bold" } },
                diagnostic_visible = { fg = colors.overlay1, bg = "NONE" },
                hint_selected = { fg = colors.crust, bg = colors.blue, style = { "bold" } },
                hint_diagnostic_selected = { fg = colors.crust, bg = colors.blue, style = { "bold" } },
                info_selected = { fg = colors.crust, bg = colors.blue, style = { "bold" } },
                info_diagnostic_selected = { fg = colors.crust, bg = colors.blue, style = { "bold" } },
                warning_selected = { fg = colors.crust, bg = colors.blue, style = { "bold" } },
                warning_diagnostic_selected = { fg = colors.crust, bg = colors.blue, style = { "bold" } },
                error_selected = { fg = colors.crust, bg = colors.blue, style = { "bold" } },
                error_diagnostic_selected = { fg = colors.crust, bg = colors.blue, style = { "bold" } },
              },
            },
          })
        end,
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-frappe",
    },
  },
}
