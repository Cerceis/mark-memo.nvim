local M = {}

-- Load config and ui modules
local config = require("mark-memo.config")
local ui = require("mark-memo.ui")

function M.setup(user_opts)
	config.setup(user_opts)
	ui.setup(config.options)

	-- Default toggle keybinding (can be changed later)
	vim.keymap.set("n", "<leader>mm", M.toggle, {
		desc = "Toggle Mark Memo",
		silent = true,
	})

	if config.options.open_on_start then
		ui.toggle()
	end
end

function M.toggle()
	ui.toggle()
end

return M
