return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    vim.treesitter.language.register("markdown", "vimwiki")
    return opts
  end,
}
