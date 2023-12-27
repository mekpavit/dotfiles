return {
  "linrongbin16/gitlinker.nvim",
  keys = {
    {
      "<leader>gy",
      "<cmd>GitLink<cr>",
      mode = { "n", "v" },
      desc = "Yank Git remot-url to clipboard",
    },
  },
  config = function()
    require("gitlinker").setup({
      router = {
        browse = {
          -- add your host here
          ["^gitlab%.agodadev%.io"] = require("gitlinker.routers").gitlab_browse,
        },
        blame = {
          -- add your host here
          ["^gitlab%.agodadev%.io"] = require("gitlinker.routers").gitlab_blame,
        },
      },
    })
  end,
}
