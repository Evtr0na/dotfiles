return {
    --------------------------------------------------------
    -- Global
    --
    -- 所有 processor / 自定义函数都可以使用
    --------------------------------------------------------

    global = {
        {
            name = "TIME",
            type = "float",
            mode = "in",
            detail = "Global time",
        },

        {
            name = "PI",
            type = "float",
            mode = "in",
            detail = "Pi constant",
        },

        {
            name = "TAU",
            type = "float",
            mode = "in",
            detail = "Tau constant",
        },

        {
            name = "E",
            type = "float",
            mode = "in",
            detail = "Euler's number",
        },
    },

    --------------------------------------------------------
    -- Spatial
    --------------------------------------------------------

    spatial = {
        ----------------------------------------------------
        -- vertex()
        ----------------------------------------------------

        vertex = {
            {
                name = "VERTEX",
                type = "vec3",
                mode = "inout",
            },

            {
                name = "NORMAL",
                type = "vec3",
                mode = "inout",
            },

            {
                name = "TANGENT",
                type = "vec3",
                mode = "inout",
            },

            {
                name = "BINORMAL",
                type = "vec3",
                mode = "inout",
            },

            {
                name = "POSITION",
                type = "vec4",
                mode = "out",
            },

            {
                name = "UV",
                type = "vec2",
                mode = "inout",
            },

            {
                name = "UV2",
                type = "vec2",
                mode = "inout",
            },

            {
                name = "COLOR",
                type = "vec4",
                mode = "inout",
            },

            {
                name = "INSTANCE_CUSTOM",
                type = "vec4",
                mode = "in",
            },

            {
                name = "INSTANCE_ID",
                type = "int",
                mode = "in",
            },

            {
                name = "VIEWPORT_SIZE",
                type = "vec2",
                mode = "in",
            },

            {
                name = "MODEL_MATRIX",
                type = "mat4",
                mode = "in",
            },

            {
                name = "VIEW_MATRIX",
                type = "mat4",
                mode = "in",
            },

            {
                name = "PROJECTION_MATRIX",
                type = "mat4",
                mode = "inout",
            },

            {
                name = "CAMERA_POSITION_WORLD",
                type = "vec3",
                mode = "in",
            },
        },

        ----------------------------------------------------
        -- fragment()
        ----------------------------------------------------

        fragment = {
            {
                name = "FRAGCOORD",
                type = "vec4",
                mode = "in",
            },

            {
                name = "FRONT_FACING",
                type = "bool",
                mode = "in",
            },

            {
                name = "VIEW",
                type = "vec3",
                mode = "in",
            },

            {
                name = "VERTEX",
                type = "vec3",
                mode = "in",
            },

            {
                name = "UV",
                type = "vec2",
                mode = "in",
            },

            {
                name = "UV2",
                type = "vec2",
                mode = "in",
            },

            {
                name = "COLOR",
                type = "vec4",
                mode = "in",
            },

            {
                name = "SCREEN_UV",
                type = "vec2",
                mode = "in",
            },

            {
                name = "NORMAL",
                type = "vec3",
                mode = "inout",
            },

            {
                name = "TANGENT",
                type = "vec3",
                mode = "inout",
            },

            {
                name = "BINORMAL",
                type = "vec3",
                mode = "inout",
            },

            {
                name = "ALBEDO",
                type = "vec3",
                mode = "out",
            },

            {
                name = "ALPHA",
                type = "float",
                mode = "out",
            },

            {
                name = "METALLIC",
                type = "float",
                mode = "out",
            },

            {
                name = "SPECULAR",
                type = "float",
                mode = "out",
            },

            {
                name = "ROUGHNESS",
                type = "float",
                mode = "out",
            },

            {
                name = "EMISSION",
                type = "vec3",
                mode = "out",
            },

            {
                name = "NORMAL_MAP",
                type = "vec3",
                mode = "out",
            },

            {
                name = "NORMAL_MAP_DEPTH",
                type = "float",
                mode = "out",
            },

            {
                name = "AO",
                type = "float",
                mode = "out",
            },

            {
                name = "RIM",
                type = "float",
                mode = "out",
            },

            {
                name = "RIM_TINT",
                type = "float",
                mode = "out",
            },

            {
                name = "CLEARCOAT",
                type = "float",
                mode = "out",
            },

            {
                name = "CLEARCOAT_ROUGHNESS",
                type = "float",
                mode = "out",
            },
        },

        ----------------------------------------------------
        -- light()
        ----------------------------------------------------

        light = {
            {
                name = "NORMAL",
                type = "vec3",
                mode = "in",
            },

            {
                name = "UV",
                type = "vec2",
                mode = "in",
            },

            {
                name = "UV2",
                type = "vec2",
                mode = "in",
            },

            {
                name = "VIEW",
                type = "vec3",
                mode = "in",
            },

            {
                name = "LIGHT",
                type = "vec3",
                mode = "in",
            },

            {
                name = "LIGHT_COLOR",
                type = "vec3",
                mode = "in",
            },

            {
                name = "ATTENUATION",
                type = "float",
                mode = "in",
            },

            {
                name = "ALBEDO",
                type = "vec3",
                mode = "in",
            },

            {
                name = "METALLIC",
                type = "float",
                mode = "in",
            },

            {
                name = "ROUGHNESS",
                type = "float",
                mode = "in",
            },

            {
                name = "DIFFUSE_LIGHT",
                type = "vec3",
                mode = "out",
            },

            {
                name = "SPECULAR_LIGHT",
                type = "vec3",
                mode = "out",
            },
        },
    },

    --------------------------------------------------------
    -- CanvasItem
    --------------------------------------------------------

    canvas_item = {
        vertex = {
            {
                name = "VERTEX",
                type = "vec2",
                mode = "inout",
            },

            {
                name = "UV",
                type = "vec2",
                mode = "inout",
            },

            {
                name = "COLOR",
                type = "vec4",
                mode = "inout",
            },

            {
                name = "INSTANCE_CUSTOM",
                type = "vec4",
                mode = "in",
            },

            {
                name = "TEXTURE_PIXEL_SIZE",
                type = "vec2",
                mode = "in",
            },

            {
                name = "MODEL_MATRIX",
                type = "mat4",
                mode = "in",
            },

            {
                name = "CANVAS_MATRIX",
                type = "mat4",
                mode = "in",
            },

            {
                name = "SCREEN_MATRIX",
                type = "mat4",
                mode = "in",
            },
        },

        fragment = {
            {
                name = "FRAGCOORD",
                type = "vec4",
                mode = "in",
            },

            {
                name = "UV",
                type = "vec2",
                mode = "in",
            },

            {
                name = "SCREEN_UV",
                type = "vec2",
                mode = "in",
            },

            {
                name = "COLOR",
                type = "vec4",
                mode = "inout",
            },

            {
                name = "NORMAL",
                type = "vec3",
                mode = "inout",
            },

            {
                name = "NORMAL_MAP",
                type = "vec3",
                mode = "out",
            },

            {
                name = "NORMAL_MAP_DEPTH",
                type = "float",
                mode = "out",
            },

            {
                name = "VERTEX",
                type = "vec2",
                mode = "inout",
            },

            {
                name = "LIGHT_VERTEX",
                type = "vec3",
                mode = "inout",
            },

            {
                name = "TEXTURE_PIXEL_SIZE",
                type = "vec2",
                mode = "in",
            },
        },

        light = {
            {
                name = "FRAGCOORD",
                type = "vec4",
                mode = "in",
            },

            {
                name = "NORMAL",
                type = "vec3",
                mode = "in",
            },

            {
                name = "COLOR",
                type = "vec4",
                mode = "in",
            },

            {
                name = "UV",
                type = "vec2",
                mode = "in",
            },

            {
                name = "SCREEN_UV",
                type = "vec2",
                mode = "in",
            },

            {
                name = "LIGHT_COLOR",
                type = "vec4",
                mode = "in",
            },

            {
                name = "LIGHT_ENERGY",
                type = "float",
                mode = "in",
            },

            {
                name = "LIGHT_POSITION",
                type = "vec3",
                mode = "in",
            },

            {
                name = "LIGHT_DIRECTION",
                type = "vec3",
                mode = "in",
            },

            {
                name = "LIGHT_VERTEX",
                type = "vec3",
                mode = "in",
            },

            {
                name = "LIGHT",
                type = "vec4",
                mode = "inout",
            },

            {
                name = "SHADOW_MODULATE",
                type = "vec4",
                mode = "out",
            },
        },
    },
}
