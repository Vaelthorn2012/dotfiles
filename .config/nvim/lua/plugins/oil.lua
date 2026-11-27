local colors = require("tokyonight.colors").setup({ style = "moon" })
local float_bg = "#0b0e17" -- try "#05070c" or "#000000" for even darker

vim.api.nvim_set_hl(0, "NormalFloat", { bg = float_bg, fg = colors.fg })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = float_bg, fg = colors.blue })
vim.api.nvim_set_hl(0, "OilDir", { fg = colors.blue, bold = true })
vim.api.nvim_set_hl(0, "OilDirIcon", { fg = colors.blue })
vim.api.nvim_set_hl(0, "OilLink", { fg = colors.magenta, italic = true })
vim.api.nvim_set_hl(0, "OilCreate", { fg = colors.green, bold = true })
vim.api.nvim_set_hl(0, "OilDelete", { fg = colors.red, bold = true })

require("oil").setup({
	default_file_explorer = true,
	delete_to_trash = true,
	skip_confirm_for_simple_edits = true,
	columns = {
		"icon",
	},
	view_options = {
		show_hidden = true,
		natural_order = true,
	},
	win_options = {
		number = false,
		relativenumber = false,
	},
	float = {
		padding = 2,
		max_width = 85,
		max_height = 28,
		border = "rounded",
		win_options = {
			winblend = 0,
		},
	},
})

vim.keymap.set("n", "-", "<cmd>Oil --float<CR>", { desc = "Open parent directory (float)" })
