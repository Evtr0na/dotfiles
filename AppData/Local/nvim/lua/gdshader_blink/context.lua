local M = {}

------------------------------------------------------------
-- 获取当前 shader_type
------------------------------------------------------------

function M.get_shader_type(bufnr)
    bufnr = bufnr or 0

    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

    for _, line in ipairs(lines) do
        local shader_type = line:match("shader_type%s+([%w_]+)%s*;")

        if shader_type then
            return shader_type
        end
    end

    return nil
end

return M
