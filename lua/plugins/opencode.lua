local ai = require("config.ai")

local opencode_cmd = "opencode"

local toggle_cmd = { opencode_cmd, "--continue" }

---@param enter boolean
local function terminal_opts(enter)
  return {
    win = {
      position = "float",
      width = 0.9,
      height = 0.9,
      border = "rounded",
      enter = enter,
    },
  }
end

local function toggle()
  require("snacks.terminal").toggle(toggle_cmd, terminal_opts(true))
end

---Pick one of the project's OpenCode sessions and reopen it in the TUI
local function resume()
  local out = vim.fn.system({ opencode_cmd, "session", "list", "--format", "json", "-n", "100" })
  if vim.v.shell_error ~= 0 then
    vim.notify("Could not list OpenCode sessions:\n" .. out, vim.log.levels.ERROR, { title = "opencode" })
    return
  end

  local ok, sessions = pcall(vim.json.decode, out)
  if not ok or type(sessions) ~= "table" or #sessions == 0 then
    vim.notify("No OpenCode sessions found for " .. vim.fn.getcwd(), vim.log.levels.WARN, { title = "opencode" })
    return
  end

  local items = {}
  for _, session in ipairs(sessions) do
    local updated = math.floor((session.updated or session.created or 0) / 1000)
    items[#items + 1] = {
      id = session.id,
      label = ("%s  (%s)"):format(session.title or session.id, os.date("%Y-%m-%d %H:%M", updated)),
    }
  end

  vim.ui.select(items, {
    prompt = "Resume OpenCode session",
    format_item = function(item)
      return item.label
    end,
  }, function(item)
    if not item then
      return
    end
    require("snacks.terminal").open({ opencode_cmd, "--session", item.id }, terminal_opts(true))
  end)
end

return {
  "nickjvandyke/opencode.nvim",
  -- Only one AI tool can be installed; see lua/config/ai.lua
  enabled = ai.enabled("opencode"),
  dependencies = { "folke/snacks.nvim" },
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      server = {
        -- Start OpenCode in a float when no server is running yet
        start = function()
          require("snacks.terminal").open(opencode_cmd, terminal_opts(false))
        end,
      },
    }

    -- Show the terminal when OpenCode starts executing
    vim.api.nvim_create_autocmd("User", {
      pattern = "OpencodeEvent:session.execution.started",
      callback = function()
        local win = require("snacks.terminal").get(toggle_cmd, { create = false })
        if win then
          win:show()
        end
      end,
    })
  end,
  keys = {
    { "<leader>a", "", desc = "+opencode", mode = { "n", "v" } },
    { "<leader>ac", toggle, desc = "Toggle OpenCode" },
    { "<leader>ar", resume, desc = "Resume OpenCode session" },
    {
      "<leader>ai",
      function()
        require("opencode").ask("@this: ")
      end,
      mode = { "n", "x" },
      desc = "Ask OpenCode",
    },
    {
      "<leader>aS",
      function()
        require("opencode").select()
      end,
      mode = { "n", "x" },
      desc = "Select OpenCode",
    },
    {
      "<leader>al",
      function()
        return require("opencode").operator("@this") .. "_"
      end,
      mode = "n",
      desc = "Send line to OpenCode",
      expr = true,
    },
    {
      "<leader>aR",
      function()
        return require("opencode").operator("@this")
      end,
      mode = { "n", "x" },
      desc = "Send range to OpenCode",
      expr = true,
    },
  },
}
