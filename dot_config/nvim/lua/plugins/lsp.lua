return {
  "neovim/nvim-lspconfig",
  init = function()
    local keys = require("lazyvim.plugins.lsp.keymaps").get()
    -- change a keymap
    keys[#keys + 1] = { "gr", "<cmd>Telescope lsp_references show_line=false<cr>" }
    keys[#keys + 1] = {
      "<leader>cl",
      function()
        vim.lsp.codelens.run()
      end,
    }
  end,
}
