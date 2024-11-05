local M = {}

function M.generate_markdown(board)
    local markdown = {}

    table.insert(markdown, "# " .. board.name .. "\n")

    for _, col in ipairs(board.order) do
        table.insert(markdown, "## " .. col .. "\n")
        for _, item in ipairs(board.columns[col]) do
            table.insert(markdown, "- [ ] " .. item)
        end

        table.insert(markdown, "\n")
    end

    return table.concat(markdown, "\n")
end

-- local board = require("kanban.board").boards["TEST"]
-- -- print(vim.inspect(board))
-- local markdown = M.generate_markdown(board)
-- print(markdown)

return M
