-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.g.mapleader = " "

local keymap = vim.keymap

-- ---------- 插入模式 ---------- ---
keymap.set("i", "jk", "<ESC>")

-- ---------- 视觉模式 ---------- ---
-- 单行或多行移动
-- keymap.set("v", "<C-s", ":m '>+1<CR>gv=gv")
-- keymap.set("v", "K", ":m '<-2<CR>gv=gv")
-- x do not yank
keymap.set("v", "x", "_x")
-- p 替换为P用来保留粘贴板
keymap.set("v", "p", "P")
keymap.set("v", "J", "^")
keymap.set("v", "K", "$")

-- ---------- 正常模式 ---------- ---
-- 全选
keymap.set("n", "vae", "ggVG")
-- 取消高亮
keymap.set("n", "<leader>nh", ":nohl<CR>")
-- 复制到下一行
keymap.set("n", "<leader>p", "o<ESC>p")
-- 移动到当前行首位置
keymap.set("n", "J", "^")
keymap.set("n", "K", "$")

--  保存
keymap.set({ "n", "i" }, "<C-s>", "<Esc>:w<cr>")

--  终端状态Esc退出
keymap.set("t", "<Esc>", "<C-\\><C-n>")

-- 选择窗口
keymap.set({ "t", "i" }, "<A-h>", "<C-\\><C-N><C-w>h", { noremap = true })
keymap.set({ "t", "i" }, "<A-j>", "<C-\\><C-N><C-w>j", { noremap = true })
keymap.set({ "t", "i" }, "<A-k>", "<C-\\><C-N><C-w>k", { noremap = true })
keymap.set({ "t", "i" }, "<A-l>", "<C-\\><C-N><C-w>l", { noremap = true })
keymap.set("n", "<A-h>", "<C-w>h", { noremap = true })
keymap.set("n", "<A-j>", "<C-w>j", { noremap = true })
keymap.set("n", "<A-k>", "<C-w>k", { noremap = true })
keymap.set("n", "<A-l>", "<C-w>l", { noremap = true })
