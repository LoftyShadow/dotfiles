return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      ["*"] = {
        keys = {
          -- Add a keymap
          -- { "H", "<cmd>echo 'hello'<cr>", desc = "Say Hello" },
          -- Change an existing keymap
          { "gh", vim.lsp.buf.hover, desc = "LSP Hover (Documentation)" }, -- 绑定 gh
          { "<leader>rn", vim.lsp.buf.rename, desc = "LSP Rename" }, -- 绑定 gh
          -- Disable a keymap
          { "K", false },
        },
      },
    },
  },
}
