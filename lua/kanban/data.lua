local M = {}

local Path = require("plenary.path")
local ensured_data_path = false

local data_path = string.format("%s/kanban/", vim.fn.stdpath("data"))

function ensure_data_path()
    if ensured_data_path then
        return
    end

    local path = Path:new(data_path)
    if not path:exists() then
        path:mkdir()
    end

    ensured_data_path = true
end

function M.write_file(file_name, content)
    ensure_data_path()

    local file_path = data_path .. "/" .. file_name

    local file = io.open(file_path, "a")

    if not file then
        print("Error opening/creating file")
        return
    end

    file:write(content)
    file:close()

    print("Created new file for board")
end

function M.read_file() end
return M
