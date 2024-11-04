local Board = {}

function Board.create_new_board(name)
	local file_name = name .. ".md"
	local content = "# " .. name .. "\n\n"

	for _, col in ipairs(require("kanban").config.default_columns) do
		content = content .. "## " .. col .. "\n\n"
	end

	require("kanban.data").write_file(file_name, content)
end

Board.create_new_board("TEST")

return Board
