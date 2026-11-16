local ai = require("config.ai")

return {
  "coder/claudecode.nvim",
  -- Only one AI tool is enabled; see lua/config/ai.lua
  enabled = ai.enabled("claude"),
  dependencies = { "folke/snacks.nvim" },
  keys = {
    { "<leader>ac", "<cmd>ClaudeCode<cr>", mode = "n", desc = "Toggle Claude" },
  },
  opts = {
    terminal = {
      provider = "snacks",
      snacks_win_opts = {
        position = "float",
        width = 0.9,
        height = 0.9,
        border = "rounded",
      },
    },
  },
}
