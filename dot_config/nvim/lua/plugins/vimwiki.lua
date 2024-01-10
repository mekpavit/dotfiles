return {
  {
    "vimwiki/vimwiki",
    keys = {
      { "<leader>ww", "<cmd>VimwikiIndex<cr>" },
      { "<C-space>", "<cmd>VimwikiToggleListItem<cr>" },
    },
    init = function(_)
      vim.g.vimwiki_list = { { ["path"] = "~/vimwiki/", ["syntax"] = "markdown", ["ext"] = ".md" } }
      vim.g.vimwiki_ext2syntax = { [".md"] = "markdown", [".markdown"] = "markdown", [".mdown"] = "markdown" }
      vim.g.vimwiki_filetypes = { "markdown" }
      vim.g.vimwiki_markdown_link_ext = 1
      vim.g.taskwiki_markdown_syntax = "markdown"
      vim.g.vimwiki_global_ext = 0
    end,
  },
  { "ribelo/taskwarrior.nvim", config = true },
  { "tools-life/taskwiki" },
}
