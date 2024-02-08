-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Disable auto-format of scala files since metals is very very slow
-- and often timeout
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "scala" },
  callback = function()
    vim.b.autoformat = false
  end,
})

-- Disable auto-format of yaml file since it messes up double-qoute and single-qoute
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "yaml", "yml" },
  callback = function()
    vim.b.autoformat = false
  end,
})
