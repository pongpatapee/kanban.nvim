local config = require("kanban").config
local M = {}

-- global boards
M.boards = {}

function M.create_new_board(name)
    local board = { name = name, columns = {}, order = {} }

    for _, col in ipairs(config.columns) do
        table.insert(board.order, col)
        board.columns[col] = {}
    end

    M.boards[name] = board

    return board
end

function M.get_board(name)
    -- TODO: if board not in memory
    -- check file sys
    -- and error check for board not existing

    return M.boards[name]
end

function M.delete_board(name)
    M.boards[name] = nil
end

function M.get_column_idx(board_name, col_name)
    local board = M.get_board(board_name)

    for i, col in ipairs(board.order) do
        if col == col_name then
            return i
        end
    end

    return -1
end

function M.add_column(board_name, col)
    local board = M.get_board(board_name)

    if board.columns[col] ~= nil then
        return
    end

    table.insert(board.order, col)
    board.columns[col] = {}
end

function M.remove_column(board_name, col)
    local board = M.get_board(board_name)

    board.columns[col] = nil
    local col_idx = M.get_column_idx(board_name, col)
    table.remove(board.order, col_idx)
end

function M.add_item(board_name, col, item)
    local board = M.get_board(board_name)
    table.insert(board.columns[col], item)
end

function M.remove_item(board_name, col, item_id) end

local MarkdownWriter = require("kanban.markdown.writer")
local Data = require("kanban.data")
local board = M.create_new_board("TEST")

-- print("Before")
-- print(vim.inspect(board))
-- M.add_column("TEST", "test_col")
-- M.add_column("TEST", "test_col2")
-- M.remove_column("TEST", "test_col")
-- M.remove_column("TEST", "Testing")
-- M.add_item("TEST", "Backlog", "what's uppp")
-- M.add_item("TEST", "Backlog", "nothing much")
-- M.add_item("TEST", "Backlog", "joe mama")
-- print("After")
-- print(vim.inspect(board))

-- print("\nBoards")
-- print(vim.inspect(M.boards))
-- local markdown_content = MarkdownWriter.generate_markdown(board)

-- Data.write_file("TEST.md", markdown_content)

-- print(markdown_content)

return M
