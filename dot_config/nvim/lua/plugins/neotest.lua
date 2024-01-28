return {
  "nvim-neotest/neotest",
  dependencies = {
    "stevanmilic/neotest-scala",
  },
  opts = {
    adapters = {
      ["neotest-scala"] = {
        runner = "bloop",
        framework = "mtest",
      },
    },
  },
}
