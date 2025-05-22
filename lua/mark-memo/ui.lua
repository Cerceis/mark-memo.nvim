local M = {}

local api = vim.api
local buf, win
local opts

function M.setup(user_opts)
	opts = user_opts
end

local function create_window()
	if buf and api.nvim_buf_is_valid(buf) then
		return
	end

	buf = api.nvim_create_buf(false, true) -- scratch buffer, no file

	-- Make it unlisted and readonly
	api.nvim_buf_set_option(buf, "buftype", "nofile")
	api.nvim_buf_set_option(buf, "bufhidden", "wipe")
	api.nvim_buf_set_option(buf, "modifiable", false)
	api.nvim_buf_set_option(buf, "swapfile", false)

	local width = opts.width or 15
	local height = opts.height or 5

	local win_opts = {
		relative = "editor",
		width = width,
		height = height,
		style = "minimal",
		border = opts.border or "rounded",
		focusable = false,
	}

	if opts.position == "topright" then
		win_opts.row = 0
		win_opts.col = vim.o.columns - width
	else
		win_opts.row = 0
		win_opts.col = 0
	end

	win = api.nvim_open_win(buf, false, win_opts)
end

function M.toggle()
	if win and api.nvim_win_is_valid(win) then
		api.nvim_win_close(win, true)
		win = nil
		buf = nil
	else
		create_window()
		M.render()
	end
end

function get_user_marks()
  local marks = vim.api.nvim_buf_get_marks(0) -- 0 = current buffer
  local user_marks = {}

  for _, mark in ipairs(marks) do
    local name = mark[1]
    if name:match("[a-zA-Z]") then  -- only named marks
      local line = mark[2] + 1  -- lines are 0-indexed
      table.insert(user_marks, string.format("%s: line %d", name, line))
    end
  end

  return user_marks
end

function M.render()
	if not buf or not api.nvim_buf_is_valid(buf) then return end

	api.nvim_buf_set_option(buf, "modifiable", true)

	local lines = {
		"Mark Memo",
		"------------",
	}
	local marks = get_user_marks()

	if #marks == 0 then
		table.insert(lines, "No marks set")
	else
		vim.list_extend(lines, marks)
	end

	api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	api.nvim_buf_set_option(buf, "modifiable", false)
end

return M
