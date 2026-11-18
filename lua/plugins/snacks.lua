return {
  "folke/snacks.nvim",
  opts = {
    lazygit = {
      configure = false,
    },
    picker = {
      sources = {
        projects = {
          dev = vim.fn.glob("~/[Ww]ork", false, true),
          recent = false,
          on_show = function(picker)
            if vim.tbl_isempty(picker.opts.dev) then
              Snacks.notify.warn("Missing projects directory. Create ~/Work and restart Neovim", { title = "Projects" })
            end
          end,
        },
        explorer = {
          layout = {
            layout = {
              position = "right",
            },
          },
        },
      },
    },
  },
}
