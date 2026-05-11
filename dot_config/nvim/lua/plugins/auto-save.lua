return {
  "Pocco81/auto-save.nvim",
  opts = {
    enabled = true, -- 开启自动保存
    trigger_events = { "InsertLeave", "FocusLost" }, -- 退出输入模式或窗口失焦时保存
    condition = function(buf)
      local fn = vim.fn
      local utils = require("auto-save.utils.data")

      -- 只有当文件确实改动了，且不是在特殊的窗口里，才保存
      if fn.getbufvar(buf, "&modifiable") == 1 and utils.not_in(fn.getbufvar(buf, "&filetype"), {}) then
        return true
      end
      return false
    end,
    write_all_buffers = false, -- 是否保存所有打开的文件
    debounce_delay = 800, -- 延迟多久保存（单位是毫秒）
  },
}
