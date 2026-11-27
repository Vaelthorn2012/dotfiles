---@diagnostic disable: undefined-global
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable built-in netrw so oil.nvim handles directory arguments cleanly
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local opt = vim.opt

-- LINE NUMBERS
opt.number = true
opt.relativenumber = true

-- TABS AND INDENTATION
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true

-- CLIPBOARD, UNDO & SWAP
opt.clipboard = "unnamedplus"
opt.undofile = true
opt.swapfile = false

-- UI & FEEL
opt.termguicolors = true
opt.signcolumn = "yes"
opt.scrolloff = 8
opt.splitright = true
opt.splitbelow = true
opt.updatetime = 250

-- KEYMAPS
local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear Search Highlights" })

map("n", "<C-h>", "<C-w>h", { desc = "Move focus to left window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move focus to right window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move focus to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move focus to upper window" })

map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
map("n", "n", "nzzzv", { desc = "Next search result centered" })
map("n", "N", "Nzzzv", { desc = "Previous search result centered" })

map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })

map("x", "<leader>p", [["_dP]], { desc = "Paste without losing clipboard" })

-- PLUGINS
vim.pack.add({
	{ src = "https://github.com/folke/tokyonight.nvim" },
	{ src = "https://github.com/ibhagwan/fzf-lua" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	"https://github.com/windwp/nvim-autopairs",
	"https://github.com/brenoprata10/nvim-highlight-colors",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
})

require("nvim-autopairs").setup({})
require("nvim-highlight-colors").setup({})

-- THEME
require("tokyonight").setup({
	style = "moon",
	transparent = true,
	terminal_colors = true,
	styles = {
		comments = { italic = true },
		keywords = { italic = false },
		functions = {},
		variables = {},
	},
})

vim.cmd.colorscheme("tokyonight")

require("plugins.oil") -- loads ~/.config/nvim/lua/oil.lua

require("lualine").setup({
	options = { theme = "tokyonight" },
})

-- FUZZY FINDER
local fzf = require("fzf-lua")
fzf.setup({})
map("n", "<leader>ff", fzf.files, { desc = "Find files" })
map("n", "<leader>fg", fzf.live_grep, { desc = "Live Grep in Project" })
map("n", "<leader>fb", fzf.buffers, { desc = "Find open Buffers" })
map("n", "<leader>fh", fzf.help_tags, { desc = "Search Neovim help" })

-- FORMATTER (conform.nvim)
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "ruff_format" },
		json = { "prettier" },
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})

-- LSP
vim.lsp.enable({ "lua_ls", "basedpyright" })

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		vim.keymap.set("n", "K", function()
			vim.lsp.buf.hover({ border = "rounded" })
		end, { buffer = args.buf })
	end,
})
