local M = {}

M.defaults = {
	width = 30,
	height = 10,
	border = "rounded",
	position = "topright",
	-- Add more defaults here
}

M.options = {}

function M.setup(user_opts)
	M.options = vim.tbl_deep_extend("force", M.defaults, user_opts or {})
end

return M
