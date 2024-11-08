--- @class Kanban
--- @field config table
--- @field boards Board[]

local M = {}

-- global boards
M.boards = {}

M.config = {
    columns = { "Backlog", "In-progress", "Testing", "Done" },
}

function M.setup(config)
    M.config = vim.tbl_deep_extend("force", M.config, config or {})

    vim.api.nvim_create_user_command("KanbanNewBoard", function(args)
        require("kanban.board").create_new_board(args.args)
    end, { nargs = 1 })
end

return M
