-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
local user_autocmds = vim.api.nvim_create_augroup("user_autocmds", { clear = true })

-- 关闭新行注释：
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  group = user_autocmds,
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})
-- 这些文件通常包含环境变量或示例配置，不走保存时格式化。
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = user_autocmds,
  pattern = { ".env", ".env.*" },
  callback = function()
    -- 直接给当前这个文件打个“禁止格式化”的标签
    vim.b.autoformat = false
  end,
})

local function sync_transparent_background()
  local transparent_groups = {
    "Normal",
    "NormalNC",
    "SignColumn",
    "EndOfBuffer",
    "LineNr",
    "CursorLineNr",
  }

  for _, group in ipairs(transparent_groups) do
    local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
    hl.bg = "NONE"
    vim.api.nvim_set_hl(0, group, hl)
  end
end

sync_transparent_background()

vim.api.nvim_create_autocmd("ColorScheme", {
  group = user_autocmds,
  pattern = "*",
  callback = sync_transparent_background,
})
