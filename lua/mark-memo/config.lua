local M = {}

M.defaults = {
	width = 15,
	height = 5,
	border = "rounded",
	position = "topright",
	toggle_key = "<leader>mm",
}

M.options = {}

function M.setup(user_opts)
	M.options = vim.tbl_deep_extend("force", M.defaults, user_opts or {})
end

return M
