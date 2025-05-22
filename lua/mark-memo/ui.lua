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

function format_mark(c, pos, separator, win_width)
	local line_num = pos[1]
	local buf = pos[3]
	local mark = c

	if line_num == 0 or buf == 0 then return nil end

	-- Try to read the line content from the buffer
	local ok, lines = pcall(vim.api.nvim_buf_get_lines, buf, line_num - 1, line_num, false)
	if not ok or not lines or #lines == 0 then return nil end

	local content = vim.trim(lines[1])
	local mark_display = string.format("%s", c)
	
	-- Calculate max preview lenggth based on window width
	local max_preview_len = win_width - #mark_display - #separator
	if max_preview_len < 0 then max_preview_len = 0 end

	-- Truncate if exceeded
	if #content > max_preview_len then
		content = content:sub(1, max_preview_len - 3) .. "..."
	end

	return string.format("%s%s%s", mark_display, separator, content)
end

function get_all_marks(separator, win_width)
	local marks = {}

	-- All marks to check: numbers, uppercase, lowercase
	local mark_symbols = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

	for c in mark_symbols:gmatch(".") do
		local ok, pos = pcall(vim.api.nvim_get_mark, c, {})
		if ok then
			-- Format: mark name, line number, and buffer/file name if global
			local formatted = format_mark(c, pos, separator, win_width)
			if formatted then
				table.insert(marks, formatted)
			end
		end
	end

	return marks
end

function M.render()
	if not buf or not api.nvim_buf_is_valid(buf) then return end
	api.nvim_buf_set_option(buf, "modifiable", true)

	local lines = {}
	local win_width = vim.api.nvim_win_get_width(win)
	local marks = get_all_marks(opts.separator, win_width)

	if #marks == 0 then
		table.insert(lines, "No marks set")
	else
		vim.list_extend(lines, marks)
	end

	api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	api.nvim_buf_set_option(buf, "modifiable", false)
end

return M
