return {
  "coder/claudecode.nvim",
  -- Only on machines where the Claude Code CLI is installed (e.g. work)
  enabled = vim.fn.executable("claude") == 1,
  opts = {
    terminal = {
      provider = "native",
      split_side = "right",
      split_width_percentage = 0.35,
    },
  },
}
