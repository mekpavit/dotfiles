-- START my vim general config
---- Remap leader to Space
vim.g.mapleader = ' ' -- <Space> to be leader shortcut
vim.api.nvim_set_keymap('i', 'jk', '<ESC>', {noremap = true}) -- to exit to normal mode
vim.api.nvim_set_keymap('i', '<C-g>', '<ESC>', {noremap = true}) -- <C-g> to exit to normal mode
vim.api.nvim_set_keymap('x', '<C-g>', '<ESC>', {noremap = true}) -- <C-g> to clear visual select
vim.api.nvim_set_keymap('n', '<C-g>', '<cmd>:noh<cr>', {noremap = true}) -- <C-g> to clear highlight
----
vim.opt.splitright = true -- always create new split windows on right side
vim.opt.splitbelow = true -- always create new split windows on bottom
vim.opt.relativenumber = true -- use relative line number
vim.opt.number = true -- show absolute line number of the current line
vim.opt.undofile = true -- keep undo history
vim.opt.tabstop = 4 -- set tab size to 4 space
vim.opt.clipboard = 'unnamedplus' -- make yank and put working with macOS native copy and paste
vim.opt.termguicolors = true -- make colors shown properly
vim.api.nvim_exec('let loaded_matchparen = 1', false) -- remove highlight on matching parentheses
---- Hightlight on yank
vim.api.nvim_exec([[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]], false)
----
---- Y yank until the end of line
vim.api.nvim_set_keymap('n', 'Y', 'y$', { noremap = true})
----
---- Remap for dealing with word wrap
vim.api.nvim_set_keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap=true, expr = true, silent = true})
vim.api.nvim_set_keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", {noremap= true, expr = true, silent = true})
----
---- Highlight all occurences of the word-under-cursor without going to the next occurrence
vim.api.nvim_set_keymap('n', '*', '*N', { noremap = true})
-- END

-- START install packer.nvim for package management
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.api.nvim_command('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
    vim.cmd [[packadd packer.nvim]]
end
vim.api.nvim_exec([[
  augroup Packer
    autocmd!
    autocmd BufWritePost init.lua PackerCompile
  augroup end
]], false)
-- END

-- START install neovim plugins
require('packer').startup(
    function(use)

        use 'wbthomason/packer.nvim'

        -- must have plugins
        use 'tpope/vim-surround' -- remap S to add one character surround the visual selected text
        use 'tpope/vim-commentary' -- add gc action to comment code
        use 'tpope/vim-sleuth' -- auto detect indent based on opening file
        use 'windwp/nvim-autopairs' -- auto pair parentheses
        use 'ggandor/lightspeed.nvim' -- jump to any 2 chars

        -- statusline
        use {
          'hoob3rt/lualine.nvim',
          requires = {'kyazdani42/nvim-web-devicons', opt = true}
        }

        -- git related
        use 'tpope/vim-fugitive' 
        use {'lewis6991/gitsigns.nvim', requires = {'nvim-lua/plenary.nvim'}}
        use 'f-person/git-blame.nvim'

        -- ready-to-use neovim's native lsp configurations
        use 'neovim/nvim-lspconfig'

        -- Debugger Protocal
        use 'mfussenegger/nvim-dap'
        use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }

        -- ready-to-use metals - LSP for Scala
        use 'scalameta/nvim-metals'

        -- ready-tu-use jdt - LSP for Java
        use 'mfussenegger/nvim-jdtls'

        -- various plugins for completion and snippeting
        use 'hrsh7th/nvim-cmp' -- Completion
        use 'hrsh7th/cmp-nvim-lsp'
        -- use 'ray-x/lsp_signature.nvim' -- Show signature while typing
        use 'nvim-lua/lsp-status.nvim' -- Show LSP server status

        -- File Explorer
        use {'kyazdani42/nvim-tree.lua', require = {'kyazdani42/nvim-web-devicons'}} 

        --[[
            Fuzzy finder that can do many useful things. What I uses here are
            - LSP -> 1. Perform code action 2. See/Goto code references
            - will try more...
        --]]
        use {'nvim-telescope/telescope.nvim', requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}}

        -- abstract all languages test runner command into 4 simple vim commands
        use 'vim-test/vim-test'

        -- better syntax highlighting
        use 'nvim-treesitter/nvim-treesitter'

        -- better lsp diagnostic buffer
        use {
            "folke/lsp-trouble.nvim",
            requires = "kyazdani42/nvim-web-devicons",
            config = function()
                require("trouble").setup({})
            end
        }

        -- for using custom linters
        use 'mfussenegger/nvim-lint'

        -- theme
        use 'dracula/vim'

        -- add indent line
        use "lukas-reineke/indent-blankline.nvim"

        -- better search panel
        use "windwp/nvim-spectre"

		-- Go related plugins
		use "buoto/gotests-vim"

    end
)
-- END

-- START config LSP
require('lspconfig').tsserver.setup({})
require('lspconfig').dartls.setup({})
require('lspconfig').pyright.setup({})
require('lspconfig').gopls.setup({
  cmd = {"gopls", "serve"},
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
      },
    },
  }
)

local system_name
if vim.fn.has("mac") == 1 then
  system_name = "macOS"
elseif vim.fn.has("unix") == 1 then
  system_name = "Linux"
elseif vim.fn.has('win32') == 1 then
  system_name = "Windows"
else
  print("Unsupported system for sumneko")
end

-- set the path to the sumneko installation; if you previously installed via the now deprecated :LspInstall, use
local sumneko_root_path = '/Users/mek.kiatkrai/lua-language-server'
local sumneko_binary = sumneko_root_path.."/bin/"..system_name.."/lua-language-server"

require('lspconfig').sumneko_lua.setup {
    cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"};
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Setup your lua path
                path = vim.split(package.path, ';'),
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {'vim'},
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = {
                    [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                    [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
                },
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
}

vim.opt_global.shortmess:remove("F"):append("c")
metalsConfig = require'metals'.bare_config()
metalsConfig.settings = {
  showImplicitArguments = true,
  excludePackages = {
    "akka.actor.typed.javadsl",
    "com.github.swagger.akka.javadsl"
  },
}
metalsConfig.on_attach = function(client, bufnr)
  require("metals").setup_dap()
end

-- metalsConfig.on_attach = function(client, bufnr)
--   require "lsp_signature".on_attach({
--     zindex = 50
--   }) -- Add this on on_attach function of any LSP config to have signature popping up
-- end

vim.cmd([[augroup lsp]])
vim.cmd([[autocmd!]])
vim.cmd([[autocmd FileType scala,sbt lua require("metals").initialize_or_attach(metalsConfig)]])
vim.cmd([[autocmd FileType java lua require("jdtls").start_or_attach({cmd = {'java-lsp.sh'}})]])
vim.cmd([[augroup end]])


-- Keymap for LSP
vim.api.nvim_set_keymap('n', '<Leader>cD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', { noremap=true, silent=true })
vim.api.nvim_set_keymap('n', 'gh', '<Cmd>lua vim.lsp.buf.hover()<CR>', { noremap=true, silent=true })
vim.api.nvim_set_keymap('n', '<Leader>cr', '<cmd>lua vim.lsp.buf.rename()<CR>', { noremap=true, silent=true })
vim.api.nvim_set_keymap('n', '[e', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', { noremap=true, silent=true })
vim.api.nvim_set_keymap('n', ']e', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', { noremap=true, silent=true })
vim.api.nvim_set_keymap("n", "<space>cf", "<cmd>lua vim.lsp.buf.formatting()<CR>", { noremap=true, silent=true })
vim.api.nvim_set_keymap("n", "<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", { noremap=true, silent=true })
-- END

-- START config telescope
local previewers = require('telescope.previewers')

local new_maker = function(filepath, bufnr, opts)
  opts = opts or {}

  filepath = vim.fn.expand(filepath)
  vim.loop.fs_stat(filepath, function(_, stat)
    if not stat then return end
    if stat.size > 100000 then
      return
    else
      previewers.buffer_previewer_maker(filepath, bufnr, opts)
    end
  end)
end

require('telescope').setup {
  defaults = {
    buffer_previewer_maker = new_maker,
  }
}
require('telescope').setup({
    defaults = {
        mappings = {
            i = {
                ["<C-j>"] = require('telescope.actions').move_selection_next,
                ["<C-k>"] = require('telescope.actions').move_selection_previous,
                ["<C-g>"] = require('telescope.actions').close,
            },
            n = {
                ["<C-g>"] = require('telescope.actions').close,
            },
        },
        buffer_previewer_maker = new_maker,
    },
})
vim.api.nvim_set_keymap('n', '<Leader>ff', '<cmd>:Telescope find_files<cr>', {noremap = true})
vim.api.nvim_set_keymap('n', '<Leader>fg', '<cmd>:Telescope live_grep<cr>', {noremap = true})
vim.api.nvim_set_keymap('n', '<Leader>bi', '<cmd>:Telescope buffers<cr>', {noremap = true})

vim.api.nvim_set_keymap('n', '<Leader>ca', '<cmd>:Telescope lsp_code_actions<cr>', {noremap = true})
vim.api.nvim_set_keymap('n', '<Leader>cR', '<cmd>:Telescope lsp_references<cr>', {noremap = true})
vim.api.nvim_set_keymap('n', '<Leader>ci', '<cmd>:Telescope lsp_implementations<cr>', {noremap = true})
vim.api.nvim_set_keymap('n', '<Leader>cd', '<cmd>:Telescope lsp_definitions<cr>', { noremap=true })

vim.api.nvim_set_keymap('n', '<Leader>gc', '<cmd>:Telescope git_commits<cr>', { noremap=true })
-- END


-- START config nvim-compe
vim.opt.completeopt = 'menuone,noselect'
local cmp = require('cmp')
cmp.setup {
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
  },
}
-- END

-- START config nvim-tree
vim.g.nvim_tree_group_empty = 1
vim.g.nvim_tree_show_icons = {
  git = 0,
  folders = 1, -- or 0,
  files = 1, -- or 0,
  folder_arrows = 1, -- or 0
}
vim.g.nvim_tree_gitignore = 0
vim.g.nvim_tree_git_hl = 0
require('nvim-tree').setup({
    view = {
        width = 50
    },
	git = {
        enable = false
    },
})
vim.api.nvim_set_keymap('n', '<Leader>op', ':NvimTreeToggle<CR>', {})
-- END

-- START config vim-test
vim.api.nvim_set_keymap("t", "jk", '<C-\\><C-n>', {noremap = true}) -- to be able to use jk on test result buffer
vim.api.nvim_set_keymap("n", "<Leader>mts", "<cmd>:TestNearest -strategy=neovim<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "<Leader>mta", "<cmd>:TestFile -strategy=neovim<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "<Leader>mtt", "<cmd>:TestLast -strategy=neovim<CR>", {noremap = true})
-- END

-- START config git-related
vim.api.nvim_set_keymap("n", "<Leader>gg", "<cmd>:Git<cr>", {noremap = true})
vim.api.nvim_set_keymap("n", "<Leader>gb", "<cmd>:GitBlameToggle<cr>", {noremap = true})
vim.g.gitblame_message_template = '<summary> • <date> • <author>'
require('gitsigns').setup()
-- END

-- START config treesitter
require('nvim-treesitter.configs').setup({
    ensure_installed = {'go'}, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    highlight = {
      enable = true,              -- false will disable the whole extension
    },
})
-- END

-- START config nvim-autopairs
require('nvim-autopairs').setup()
-- END

-- START config lsp-trouble
vim.api.nvim_set_keymap('n', '<Leader>ce', '<cmd>:TroubleToggle lsp_document_diagnostics<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<Leader>cE', '<cmd>:TroubleToggle lsp_workspace_diagnostics<CR>', {noremap = true})
-- END

-- START config lint
require('lint').linters_by_ft = {
  go = {'golangcilint',}
}
vim.api.nvim_exec("au FileType go au BufWritePost <buffer> lua require('lint').try_lint()", false) -- auto run golangci-lint on *.go file
-- END

-- START config statusline
local function getCurrentRelativeFilePath()
  return vim.fn['fnamemodify'](vim.fn['expand']('%'), ":~:.")
end

require'lualine'.setup {
  options = {
    icons_enabled = true,
    theme = 'onedark',
    component_separators = {'', ''},
    section_separators = {'', ''},
    disabled_filetypes = {}
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch'},
    lualine_c = {getCurrentRelativeFilePath},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {require'lsp-status'.status}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}
-- END

-- START config theme
vim.cmd[[syntax enable]]
vim.cmd[[colorscheme dracula]]
-- END

-- START config indent blank line
vim.opt.list = true
vim.opt.listchars:append("space:⋅")
vim.opt.listchars:append("eol:↴")

require("indent_blankline").setup {
    show_end_of_line = true,
    space_char_blankline = " ",
}
-- END

-- START config search panel
vim.api.nvim_set_keymap('n', '<Leader>fs', "<cmd>:lua require('spectre').open()<CR>", {noremap = true})
-- END


-- START config DAP
local dap = require("dap")
dap.configurations.scala = {
  {
    type = "scala",
    request = "launch",
    name = "Run",
    metals = {
      runType = "run",
    },
  },
  {
    type = "scala",
    request = "launch",
    name = "Test File",
    metals = {
      runType = "testFile",
    },
  },
  {
    type = "scala",
    request = "launch",
    name = "Test Target",
    metals = {
      runType = "testTarget",
    },
  },
}
require("dapui").setup()
-- END
