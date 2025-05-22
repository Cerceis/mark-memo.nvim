local M = {}

-- Load config and ui modules
local config = require("mark-memo.config")
local ui = require("mark-memo.ui")

function M.setup(user_opts)
	config.setup(user_opts)
	ui.setup(config.options)
	ui.toggle()
end

function M.toggle()
	ui.toggle()
end

return M
