return {
  "coder/claudecode.nvim",
  -- Only on machines where the Claude Code CLI is installed (e.g. work)
  enabled = vim.fn.executable("claude") == 1,
  dependencies = { "folke/snacks.nvim" },
  keys = {
    { "<leader>ac", "<cmd>ClaudeCode<cr>", mode = "n", desc = "Toggle Claude (float)" },
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
