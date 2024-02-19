return {
  {
    "scalameta/nvim-metals",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "mfussenegger/nvim-dap",
        config = function(self, opts)
          -- Debug settings if you're using nvim-dap
          local dap = require("dap")

          dap.configurations.scala = {
            {
              type = "scala",
              request = "launch",
              name = "RunOrTest",
              metals = {
                runType = "runOrTestFile",
                --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
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
            {
              type = "scala",
              request = "attach",
              name = "Attach debugger to Metals server",
              buildTarget = "metals",
              hostName = "localhost",
              port = 5005,
            },
          }
        end,
      },
    },
    ft = { "scala", "sbt" },
    opts = function()
      local metals_config = require("metals").bare_config()

      -- Example of settings
      metals_config.settings = {
        showImplicitArguments = true,
        excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
        testUserInterface = "Test Explorer",
      }

      -- *READ THIS*
      -- I *highly* recommend setting statusBarProvider to true, however if you do,
      -- you *have* to have a setting to display this in your statusline or else
      -- you'll not see any messages from metals. There is more info in the help
      -- docs about this
      metals_config.init_options.statusBarProvider = "off"

      -- Example if you are using cmp how to make sure the correct capabilities for snippets are set
      metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

      metals_config.capabilities.workspace = {
        didChangeWatchedFiles = {
          dynamicRegistration = false,
        },
      }

      metals_config.on_attach = function(_, _)
        require("metals").setup_dap()
      end

      -- Override metals/stauts to send to Noice mini
      return metals_config
    end,
    config = function(self, metals_config)
      local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = self.ft,
        callback = function()
          require("metals").initialize_or_attach(metals_config)
        end,
        group = nvim_metals_group,
      })
    end,
  },
}
