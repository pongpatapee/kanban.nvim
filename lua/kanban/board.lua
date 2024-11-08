local Kanban = require("kanban")
local Utils = require("kanban.utils")

-- Might change task from string to table
--- @alias Task any

--- @class Board
--- @field name string
--- @field columns table<string, Task[]>
--- @field col_order string[]
local M = {}

-- Board functions

--- @param name string
--- @return Board
function M.create_new_board(name)
    local board = { name = name, columns = {}, col_order = {} }

    for _, col in ipairs(Kanban.config.columns) do
        table.insert(board.col_order, col)
        board.columns[col] = {}
    end

    Kanban.boards[name] = board

    return board
end

--- @param name string
--- @return Board
function M.get_board(name)
    -- TODO: if board not in memory
    -- check file sys
    -- and error check for board not existing

    return Kanban.boards[name]
end

--- @param name string
function M.delete_board(name)
    Kanban.boards[name] = nil
end

-- Column functions

--- @param board_name string
--- @param col string
--- @return integer
function M.get_column_idx(board_name, col)
    local board = M.get_board(board_name)

    for i, col_name in ipairs(board.col_order) do
        if col_name == col then
            return i
        end
    end

    return -1
end

--- @param board_name string
--- @param col string
function M.add_column(board_name, col)
    local board = M.get_board(board_name)

    if board.columns[col] ~= nil then
        return
    end

    table.insert(board.col_order, col)
    board.columns[col] = {}
end

--- @param board_name string
--- @param col string
function M.remove_column(board_name, col)
    local board = M.get_board(board_name)

    board.columns[col] = nil
    local col_idx = M.get_column_idx(board_name, col)
    table.remove(board.col_order, col_idx)
end

-- Task Functions

--- @param board_name string
--- @param col string
--- @param task Task
function M.add_task(board_name, col, task)
    local board = M.get_board(board_name)
    table.insert(board.columns[col], task)
end

--- @param board_name string
--- @param col string
--- @param task_idx integer
--- @return Task | nil
function M.pop_task(board_name, col, task_idx)
    local board = M.get_board(board_name)
    return table.remove(board.columns[col], task_idx)
end

--- @param board_name string
--- @param src_col string
--- @param dst_col string
--- @param src_task_idx integer
function M.move_task(board_name, src_col, dst_col, src_task_idx)
    local popped = M.pop_task(board_name, src_col, src_task_idx)
    M.add_task(board_name, dst_col, popped)
end

--- @param board_name string
--- @param col string
--- @param task_idx integer
--- @param dir "'U'" | "'D'"
function M.reorder_task(board_name, col, task_idx, dir)
    local board = M.get_board(board_name)
    local tasks = board.columns[col]

    if dir == "U" then
        if task_idx <= 1 then
            return
        end

        local dst_idx = task_idx - 1
        Utils.swap(tasks, task_idx, dst_idx)
    elseif dir == "D" then
        if task_idx >= #tasks then
            return
        end

        local dst_idx = task_idx + 1
        Utils.swap(tasks, task_idx, dst_idx)
    else
        print("Direction not supported")
    end
end

local MarkdownWriter = require("kanban.markdown.writer")
local Data = require("kanban.data")
local board = M.create_new_board("TEST")

M.add_column("TEST", "test_col")
M.add_column("TEST", "test_col2")
M.remove_column("TEST", "test_col")
M.remove_column("TEST", "Testing")
M.add_task("TEST", "Backlog", "what's uppp")
M.add_task("TEST", "Backlog", "nothing much")
M.add_task("TEST", "Backlog", "joe mama")
print("Before")
print(vim.inspect(board))
-- M.pop_task("TEST", "Backlog", 2)
-- M.move_task("TEST", "Backlog", "Done", 1)
M.reorder_task("TEST", "Backlog", 2, "D")
M.reorder_task("TEST", "Backlog", 3, "D")
print("After")
print(vim.inspect(board))

-- print("\nBoards")
-- print(vim.inspect(Kanban.boards))
-- local markdown_content = MarkdownWriter.write(board)

-- Data.write_file("TEST.md", markdown_content)

-- print(markdown_content)

return M
