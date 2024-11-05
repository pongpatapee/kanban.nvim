local M = {}

function M.swap(tbl, idx1, idx2)
    local temp = tbl[idx1]
    tbl[idx1] = tbl[idx2]
    tbl[idx2] = temp
end

return M
