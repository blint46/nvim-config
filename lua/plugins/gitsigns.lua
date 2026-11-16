return {
  "lewis6991/gitsigns.nvim",
  lazy = false,
  opts = {
    current_line_blame = true,
    current_line_blame_opts = {
      delay = 300,
      virt_text_pos = "eol",
    },
  },
  keys = {
    {
      "<leader>uB",
      function()
        require("gitsigns").toggle_current_line_blame()
      end,
      desc = "Toggle Line Blame",
    },
    {
      "<leader>ghw",
      function()
        require("gitsigns").toggle_word_diff()
      end,
      desc = "Toggle Word Diff",
    },
  },
}
