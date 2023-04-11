local M = {}

local function begin_with(String, Start)
	return string.sub(String, 1, string.len(Start)) == Start
end

local function slice(tbl, first, last, step)
	local sliced = {}

	for i = first or 1, last or #tbl, step or 1 do
		sliced[#sliced + 1] = tbl[i]
	end

	return sliced
end

local function ltrim(s)
	return (s:gsub("^%s*", ""))
end

local function find_begin_with_ltrim(lines, str, start, step)
	while start > 0 and start <= #lines do
		if begin_with(ltrim(lines[start]), str) then
			return start
		end

		start = start + step
	end

	return nil
end

local function find_block_code(lines, cursor_row, delimiter)
	local begin = find_begin_with_ltrim(lines, delimiter, cursor_row, -1)
	local e = find_begin_with_ltrim(lines, delimiter, cursor_row + 1, 1)

	return table.concat(slice(lines, (begin and { begin + 1 } or { nil })[1], (e and { e - 1 } or { nil })[1]), "\n")
end

local delimiters = {
	python = "# %%",
	typescript = "// %%",
	typescriptreact = "// %%",
	javascript = "// %%",
	sh = "# %%",
	lua = "-- %",
}

local function getDelimiter(ft)
	return delimiters[ft]
end

function M.eval_block()
	local content = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	-- print("content", content)
	local line = vim.api.nvim_win_get_cursor(0)[1]

	local delimiter = getDelimiter(vim.bo.filetype)

	if not delimiter then
		return
	end

	local snip = find_block_code(content, line, delimiter)
	-- pprint(snip)

	local core = require("iron.core")
	core.send(nil, snip)
end

return M
