-- Enable the single AI assistant whose CLI is installed.
--
-- Installing both is treated as a configuration error: nothing is enabled

local M = {}

local available = {
  opencode = vim.fn.executable("opencode") == 1,
  claude = vim.fn.executable("claude") == 1,
}

if available.opencode and available.claude then
  vim.notify(
    "Both `opencode` and `claude` are installed. Uninstall one of them; no AI plugin will be enabled.",
    vim.log.levels.ERROR,
    { title = "config.ai" }
  )
elseif available.opencode then
  M.tool = "opencode"
elseif available.claude then
  M.tool = "claude"
end

---@param tool "opencode" | "claude"
---@return boolean
function M.enabled(tool)
  return M.tool == tool
end

return M
