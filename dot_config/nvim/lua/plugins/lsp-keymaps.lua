return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      ["*"] = {
        keys = {
          -- Add a keymap
          -- { "H", "<cmd>echo 'hello'<cr>", desc = "Say Hello" },
          -- Change an existing keymap
          { "K", vim.lsp.buf.hover, desc = "LSP Hover (Documentation)" },
          { "<leader>rn", vim.lsp.buf.rename, desc = "LSP Rename" },
        },
      },
    },
  },
}
