return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    {
      "nvim-telescope/telescope-live-grep-args.nvim",
      -- This will not install any breaking changes.
      -- For major updates, this must be adjusted manually.
      version = "^1.0.0",
      config = function()
        require("telescope").load_extension("live_grep_args")
      end,
    },
  },
  keys = {
    {
      "<leader>fg",
      function()
        require("telescope").extensions.live_grep_args.live_grep_args()
      end,
      desc = "Find in files (with args)",
    },
  },
  opts = {
    defaults = {
      layout_strategy = "vertical",
      mappings = {
        i = {
          ["<C-i>"] = function(prompt_bufnr)
            require("telescope-live-grep-args.actions").quote_prompt({ postfix = " --iglob " })(prompt_bufnr)
          end,
        },
      },
    },
    extensions = {
      live_grep_args = {
        auto_quoting = true,
      },
    },
  },
}
