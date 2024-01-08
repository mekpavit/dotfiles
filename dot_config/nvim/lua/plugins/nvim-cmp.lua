return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "mekpavit/cmp-dap",
  },
  opts = function(_, opts)
    local cmp = require("cmp")
    opts.sources = cmp.config.sources(vim.list_extend(opts.sources, { { name = "dap" } }))
    opts.enabled = function()
      return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
    end
  end,
}
