local source = {}

------------------------------------------------------------
-- Dependencies
------------------------------------------------------------

local kinds = require("blink.cmp.types").CompletionItemKind

local context = require("gdshader_blink.context")

local render_modes = require("gdshader_blink.data.render_modes")

local swizzles = require("gdshader_blink.data.swizzles")

------------------------------------------------------------
-- Static data
------------------------------------------------------------

local shader_types = {
    {
        label = "spatial",
        kind = kinds.Keyword,
        detail = "GDShader shader type",
    },
    {
        label = "canvas_item",
        kind = kinds.Keyword,
        detail = "GDShader shader type",
    },
    {
        label = "particles",
        kind = kinds.Keyword,
        detail = "GDShader shader type",
    },
    {
        label = "sky",
        kind = kinds.Keyword,
        detail = "GDShader shader type",
    },
    {
        label = "fog",
        kind = kinds.Keyword,
        detail = "GDShader shader type",
    },
}

local general_items = {
    --------------------------------------------------------
    -- Keywords
    --------------------------------------------------------

    {
        label = "shader_type",
        kind = kinds.Keyword,
        detail = "GDShader keyword",
    },

    {
        label = "render_mode",
        kind = kinds.Keyword,
        detail = "GDShader keyword",
    },

    {
        label = "uniform",
        kind = kinds.Keyword,
        detail = "GDShader keyword",
    },

    {
        label = "varying",
        kind = kinds.Keyword,
        detail = "GDShader keyword",
    },

    {
        label = "const",
        kind = kinds.Keyword,
        detail = "GDShader keyword",
    },

    --------------------------------------------------------
    -- Types
    --------------------------------------------------------

    {
        label = "float",
        kind = kinds.TypeParameter,
        detail = "GDShader type",
    },

    {
        label = "int",
        kind = kinds.TypeParameter,
        detail = "GDShader type",
    },

    {
        label = "bool",
        kind = kinds.TypeParameter,
        detail = "GDShader type",
    },

    {
        label = "vec2",
        kind = kinds.TypeParameter,
        detail = "GDShader type",
    },

    {
        label = "vec3",
        kind = kinds.TypeParameter,
        detail = "GDShader type",
    },

    {
        label = "vec4",
        kind = kinds.TypeParameter,
        detail = "GDShader type",
    },

    {
        label = "mat3",
        kind = kinds.TypeParameter,
        detail = "GDShader type",
    },

    {
        label = "mat4",
        kind = kinds.TypeParameter,
        detail = "GDShader type",
    },

    --------------------------------------------------------
    -- 临时 built-in functions
    --
    -- 下一步会把这些移动到 data/builtin_functions.lua
    --------------------------------------------------------

    {
        label = "mix",
        kind = kinds.Snippet,
        detail = "GDShader built-in function",

        insertText = "mix(${1:a}, ${2:b}, ${3:weight})",

        insertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet,
    },

    {
        label = "clamp",
        kind = kinds.Snippet,
        detail = "GDShader built-in function",

        insertText = "clamp(${1:value}, ${2:min}, ${3:max})",

        insertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet,
    },

    {
        label = "texture",
        kind = kinds.Snippet,
        detail = "GDShader built-in function",

        insertText = "texture(${1:sampler}, ${2:uv})",

        insertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet,
    },
}

------------------------------------------------------------
-- Item builders
------------------------------------------------------------

local function make_render_mode_items(shader_type)
    local items = {}

    local modes = render_modes[shader_type] or {}

    for _, name in ipairs(modes) do
        table.insert(items, {
            label = name,
            kind = kinds.EnumMember,

            detail = "GDShader " .. shader_type .. " render mode",
        })
    end

    return items
end

local function make_swizzle_items(vector_size, type_name)
    local items = {}

    for _, name in ipairs(swizzles.for_size(vector_size)) do
        table.insert(items, {
            label = name,
            kind = kinds.Field,

            detail = type_name .. " swizzle",
        })
    end

    return items
end

local function make_builtin_variable_items(bufnr, cursor_line)
    local items = {}

    local variables = context.get_builtin_variables(bufnr, cursor_line)

    for _, variable in ipairs(variables) do
        table.insert(items, {
            label = variable.name,
            kind = kinds.Variable,

            detail = variable.mode .. " " .. variable.type .. " · GDShader built-in",
        })
    end

    return items
end

local function make_context_items(ctx, cursor_line)
    local items = vim.deepcopy(general_items)

    vim.list_extend(items, make_builtin_variable_items(ctx.bufnr, cursor_line))

    return items
end

------------------------------------------------------------
-- Blink source
------------------------------------------------------------

function source.new()
    return setmetatable({}, {
        __index = source,
    })
end

------------------------------------------------------------
-- Enabled
------------------------------------------------------------

function source:enabled()
    local ft = vim.bo.filetype

    return ft == "gdshader" or ft == "gdshaderinc"
end

------------------------------------------------------------
-- Trigger characters
------------------------------------------------------------

function source:get_trigger_characters()
    return {
        ".",
        " ",
    }
end

------------------------------------------------------------
-- Completion
------------------------------------------------------------

function source:get_completions(ctx, callback)
    --------------------------------------------------------
    -- Cursor context
    --------------------------------------------------------

    local line = vim.api.nvim_get_current_line()

    local cursor = vim.api.nvim_win_get_cursor(0)

    local cursor_line = cursor[1]

    -- column 是 0-based
    local col = cursor[2]

    local before_cursor = line:sub(1, col)

    local items = {}

    --------------------------------------------------------
    -- shader_type
    --------------------------------------------------------

    if before_cursor:match("shader_type%s+[%w_]*$") then
        items = shader_types

    --------------------------------------------------------
    -- render_mode
    --------------------------------------------------------
    elseif before_cursor:match("render_mode%s+[%w_]*$") then
        local shader_type = context.get_shader_type(ctx.bufnr)

        if shader_type then
            items = make_render_mode_items(shader_type)
        end

    --------------------------------------------------------
    -- Swizzle
    --------------------------------------------------------
    elseif before_cursor:match("%.[%w_]*$") then
        local identifier = context.get_identifier_before_dot(before_cursor)

        if identifier then
            local type_name = context.get_symbol_type(ctx.bufnr, identifier, cursor_line)

            if type_name then
                local vector_size = context.get_vector_size(type_name)

                if vector_size then
                    items = make_swizzle_items(vector_size, type_name)
                end
            end
        end

    --------------------------------------------------------
    -- General + context-aware built-ins
    --------------------------------------------------------
    else
        items = make_context_items(ctx, cursor_line)
    end

    --------------------------------------------------------
    -- Return
    --------------------------------------------------------

    callback({
        items = items,

        is_incomplete_forward = false,
        is_incomplete_backward = false,
    })
end

return source
