local source = {}

local kinds = require("blink.cmp.types").CompletionItemKind
local context = require("gdshader_blink.context")
local render_modes = require("gdshader_blink.data.render_modes")

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

--------------------------------------------------------
--#data
--------------------------------------------------------

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
    --#Keyword
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
    -- constn
    --------------------------------------------------------

    {
        label = "PI",
        kind = kinds.Constant,
        detail = "GDShader constant",
    },

    {
        label = "TAU",
        kind = kinds.Constant,
        detail = "GDShader constant",
    },

    {
        label = "E",
        kind = kinds.Constant,
        detail = "GDShader constant",
    },

    --------------------------------------------------------
    -- Built-in variables
    --------------------------------------------------------

    {
        label = "UV",
        kind = kinds.Variable,
        detail = "GDShader built-in",
    },

    {
        label = "COLOR",
        kind = kinds.Variable,
        detail = "GDShader built-in",
    },

    {
        label = "ALBEDO",
        kind = kinds.Variable,
        detail = "GDShader built-in",
    },

    {
        label = "NORMAL",
        kind = kinds.Variable,
        detail = "GDShader built-in",
    },

    --------------------------------------------------------
    -- Built-in function snippets
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

local swizzles = {
    "x",
    "y",
    "z",
    "w",

    "r",
    "g",
    "b",
    "a",

    "s",
    "t",
    "p",
    "q",

    "xy",
    "xyz",
    "xyzw",

    "rg",
    "rgb",
    "rgba",
}

------------------------------------------------------------
-- Blink source
------------------------------------------------------------

function source.new()
    return setmetatable({}, {
        __index = source,
    })
end

------------------------------------------------------------
-- 只在 GDShader 中启用
------------------------------------------------------------

function source:enabled()
    local ft = vim.bo.filetype

    return ft == "gdshader" or ft == "gdshaderinc"
end

------------------------------------------------------------
-- "." 时重新请求补全
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
    local line = vim.api.nvim_get_current_line()

    -- nvim_win_get_cursor 的 column 是 0-based
    local col = vim.api.nvim_win_get_cursor(0)[2]

    local before_cursor = line:sub(1, col)

    local items = {}

    --------------------------------------------------------
    -- shader_type xxx
    --------------------------------------------------------

    if before_cursor:match("shader_type%s+[%w_]*$") then
        items = shader_types
    elseif before_cursor:match("render_mode%s+[%w_]*$") then
        local shader_type = context.get_shader_type(ctx.bufnr)

        if shader_type then
            items = make_render_mode_items(shader_type)
        end
    elseif before_cursor:match("%.[%w_]*$") then
    -- swizzle
    else
        items = general_items
    end

    --------------------------------------------------------
    -- 返回给 Blink
    --------------------------------------------------------

    callback({
        -- Blink 会修改返回的 item，
        -- 所以缓存的数据最好 deepcopy。
        items = vim.deepcopy(items),

        is_incomplete_forward = false,
        is_incomplete_backward = false,
    })
end

return source
