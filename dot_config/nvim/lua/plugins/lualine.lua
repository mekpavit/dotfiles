return {
  "nvim-lualine/lualine.nvim",
  opts = {
    sections = {
      lualine_x = {
        {
          function()
            return vim.g["metals_status"]
          end,
        },
      },
    },
  },
}
