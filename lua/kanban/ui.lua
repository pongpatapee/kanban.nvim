local Layout = require("nui.layout")
local Popup = require("nui.popup")

--- @class KanbanUI
local M = {}

M.board = {}
M.columns = {}
M.winid = nil
M.state = {
    column_idx = 1,
}

--- @param board Board
function M:render(board)
    local boxes = {}

    for i, col in ipairs(board.col_order) do
        local popup = Popup({
            border = {
                style = "single",
                text = {
                    top = col,
                },
            },
            enter = i == 1,
        })

        table.insert(self.columns, popup)
        table.insert(boxes, Layout.Box(popup, { size = tostring(100 / #board.col_order) .. "%" }))
    end

    local board_layout = Layout({
        text = {
            top = board.name,
        },
        relative = "editor",
        position = "50%",
        size = {
            width = "90%",
            height = "90%",
        },
    }, Layout.Box(boxes, { dir = "row" }))

    board_layout:mount()

    self.board = board_layout
    self.winid = board_layout.winid

    return board_layout
end

function M:nav_column(dir)
    if self.board == nil then
        return
    end

    if dir == "L" then
        if self.state.column_idx == 1 then
            return
        end

        self.state.column_idx = self.state.column_idx - 1
    end
    if dir == "R" then
        if self.state.column_idx == 1 then
            return
        end

        self.state.column_idx = self.state.column_idx + 1
    end

    local winid = self.columns[self.state.column_idx].winid
    vim.api.nvim_set_current_win(winid)
end

local board = {
    name = "my kanban",
    columns = {
        backlog = { "task1", "task2" },
        doing = { "task_a" },
        testing = { "task_b" },
        done = {},
    },
    col_order = { "backlog", "doing", "testing", "done" },
}

M:render(board)

return M
