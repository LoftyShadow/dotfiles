-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
-- 关闭新行注释：
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = "*",
  callback = function()
    vim.opt.formatoptions = vim.opt.formatoptions - { "c", "r", "o" }
  end,
})
-- 当你要保存文件之前，Neovim 会执行这里的检查
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { ".env", ".env.*", "*.example" }, -- 匹配所有 .env 开头或 example 结尾的文件
  callback = function()
    -- 直接给当前这个文件打个“禁止格式化”的标签
    vim.b.autoformat = false
    -- 强制让负责格式化的插件跳过这个文件
    vim.g.autoformat = false
  end,
})

-- 为了不影响其他文件，保存完后再把全局开关打开（可选）
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { ".env", ".env.*", "*.example" },
  callback = function()
    vim.g.autoformat = true
  end,
})
