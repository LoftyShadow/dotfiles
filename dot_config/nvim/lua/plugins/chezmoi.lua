return {
  "xvzc/chezmoi.nvim",
  config = function()
    require("chezmoi").setup({})

    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      pattern = "*",
      callback = function()
        local filepath = vim.api.nvim_buf_get_name(0)
        if filepath == "" then
          return
        end

        -- 检查是否受管理
        local handle = io.popen("chezmoi managed " .. filepath)
        local result = handle:read("*a")
        handle:close()

        if result ~= "" then
          -- 自动执行 add 并直接 commit（提交），备注为 "auto update"
          -- 这样你在 status 里就看不到它了，因为它已经存入历史了
          vim.fn.jobstart({ "chezmoi", "add", filepath })
          -- 如果你想更彻底，可以取消下面这行的注释（前提是你的 chezmoi 仓库初始化了 git）
          vim.fn.jobstart({ "chezmoi", "git", "commit", "--", "-m", "Auto-update config" })
        end
      end,
    })
  end,
}
