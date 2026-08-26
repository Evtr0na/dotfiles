local M = {}
local builtin_variables = require("gdshader_blink.data.builtin_variables")
------------------------------------------------------------
-- Vector 类型
------------------------------------------------------------

local vector_sizes = {
    vec2 = 2,
    vec3 = 3,
    vec4 = 4,

    ivec2 = 2,
    ivec3 = 3,
    ivec4 = 4,

    uvec2 = 2,
    uvec3 = 3,
    uvec4 = 4,

    bvec2 = 2,
    bvec3 = 3,
    bvec4 = 4,
}

------------------------------------------------------------
-- 查找 built-in variable
------------------------------------------------------------

function M.get_builtin_variable(bufnr, name, cursor_line)
    local variables = M.get_builtin_variables(bufnr, cursor_line)

    for _, item in ipairs(variables) do
        if item.name == name then
            return item
        end
    end

    return nil
end

------------------------------------------------------------
-- 获取当前上下文允许的 built-in variables
------------------------------------------------------------

function M.get_builtin_variables(bufnr, cursor_line)
    local result = {}

    --------------------------------------------------------
    -- Global built-ins
    --------------------------------------------------------

    for _, item in ipairs(builtin_variables.global or {}) do
        table.insert(result, item)
    end

    --------------------------------------------------------
    -- Shader type
    --------------------------------------------------------

    local shader_type = M.get_shader_type(bufnr)

    if not shader_type then
        return result
    end

    local shader_data = builtin_variables[shader_type]

    if not shader_data then
        return result
    end

    --------------------------------------------------------
    -- Processor
    --------------------------------------------------------

    local processor = M.get_processor(bufnr, cursor_line)

    if not processor then
        return result
    end

    local processor_data = shader_data[processor]

    if not processor_data then
        return result
    end

    --------------------------------------------------------
    -- Processor-specific built-ins
    --------------------------------------------------------

    for _, item in ipairs(processor_data) do
        table.insert(result, item)
    end

    return result
end

------------------------------------------------------------
-- 获取当前所在函数
--
-- 例如：
--
-- void fragment() {
--     ...
-- }
--
-- 返回 "fragment"
------------------------------------------------------------

function M.get_processor(bufnr, cursor_line)
    bufnr = bufnr or 0

    cursor_line = cursor_line or vim.api.nvim_win_get_cursor(0)[1]

    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, cursor_line, false)

    local brace_depth = 0

    local current_function = nil
    local function_depth = nil
    local pending_function = nil

    for _, original_line in ipairs(lines) do
        ----------------------------------------------------
        -- 第一版先去掉 // comment
        ----------------------------------------------------

        local line = original_line:gsub("//.*$", "")

        ----------------------------------------------------
        -- 找函数声明
        --
        -- void fragment()
        -- void vertex()
        -- void light()
        -- void my_function(...)
        ----------------------------------------------------

        local function_name = line:match("void%s+([%a_][%w_]*)%s*%(")

        if function_name then
            pending_function = function_name
        end

        ----------------------------------------------------
        -- 计算大括号
        ----------------------------------------------------

        local _, open_count = line:gsub("{", "")

        local _, close_count = line:gsub("}", "")

        ----------------------------------------------------
        -- 函数真正开始
        ----------------------------------------------------

        if pending_function and open_count > 0 then
            current_function = pending_function

            function_depth = brace_depth + 1

            pending_function = nil
        end

        brace_depth = brace_depth + open_count - close_count

        ----------------------------------------------------
        -- 离开函数
        ----------------------------------------------------

        if current_function and function_depth and brace_depth < function_depth then
            current_function = nil
            function_depth = nil
        end
    end

    return current_function
end

------------------------------------------------------------
-- 获取 shader_type
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

------------------------------------------------------------
-- 获取 "." 前面的 identifier
------------------------------------------------------------

function M.get_identifier_before_dot(before_cursor)
    return before_cursor:match("([%a_][%w_]*)%.[%w_]*$")
end

------------------------------------------------------------
-- 从代码中寻找变量声明
------------------------------------------------------------

local function find_declared_type(bufnr, name, cursor_line)
    bufnr = bufnr or 0

    cursor_line = cursor_line or vim.api.nvim_win_get_cursor(0)[1]

    --------------------------------------------------------
    -- 只扫描当前光标之前
    --------------------------------------------------------

    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, cursor_line, false)

    --------------------------------------------------------
    -- 从后往前找
    --
    -- 这样局部变量优先于更早的同名变量
    --------------------------------------------------------

    for i = #lines, 1, -1 do
        local line = lines[i]

        -- 第一版先去掉 // comment
        line = line:gsub("//.*$", "")

        ----------------------------------------------------
        -- 支持：
        --
        -- vec3 color;
        -- vec3 color = ...
        -- uniform vec3 color;
        -- const vec3 color = ...
        -- varying vec3 color;
        --
        -- void foo(vec3 color)
        --
        -- vec3 colors[4];
        ----------------------------------------------------

        local pattern = "([%a_][%w_]*)" .. "%s+" .. name .. "%s*" .. "[,;=%)%[]"

        local value_type = line:match(pattern)

        if value_type then
            return value_type
        end
    end

    return nil
end

------------------------------------------------------------
-- 获取 identifier 类型
------------------------------------------------------------
function M.get_symbol_type(bufnr, name, cursor_line)
    --------------------------------------------------------
    -- 用户声明
    --------------------------------------------------------

    local declared_type = find_declared_type(bufnr, name, cursor_line)

    if declared_type then
        return declared_type
    end

    --------------------------------------------------------
    -- GDShader built-in
    --------------------------------------------------------

    local builtin = M.get_builtin_variable(bufnr, name, cursor_line)

    if builtin then
        return builtin.type
    end

    return nil
end
------------------------------------------------------------
-- 类型 -> vector size
------------------------------------------------------------

function M.get_vector_size(type_name)
    return vector_sizes[type_name]
end

return M
