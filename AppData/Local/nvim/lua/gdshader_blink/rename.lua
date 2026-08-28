local M = {}

local semantic_references = require("gdshader_blink.semantic.references")

local token = require("gdshader_blink.syntax.token")

local TokenKind = token.Kind

local configured = false

------------------------------------------------------------
-- Supported
------------------------------------------------------------

local function is_supported(bufnr)
    if not vim.api.nvim_buf_is_valid(bufnr) then
        return false
    end

    local ft = vim.bo[bufnr].filetype

    return ft == "gdshader" or ft == "gdshaderinc"
end

------------------------------------------------------------
-- Identifier validation
------------------------------------------------------------

local function is_valid_name(name)
    if not name or not name:match("^[%a_][%w_]*$") then
        return false
    end

    --------------------------------------------------------
    -- 拒绝：
    --
    -- if
    -- return
    -- vec3
    -- float
    -- true
    -- false
    -- ...
    --------------------------------------------------------

    return token.classify_word(name) == TokenKind.IDENTIFIER
end

------------------------------------------------------------
-- Target
------------------------------------------------------------

local function current_target(bufnr)
    local cursor = vim.api.nvim_win_get_cursor(0)

    return semantic_references.target_at(bufnr, cursor[1] - 1, cursor[2])
end

------------------------------------------------------------
-- Apply
------------------------------------------------------------

local function apply_rename(bufnr, target, new_name)
    if not is_valid_name(new_name) then
        vim.notify("GDShader: invalid identifier '" .. tostring(new_name) .. "'", vim.log.levels.ERROR)

        return
    end

    if new_name == target.name then
        return
    end

    local references = semantic_references.find(bufnr, target)

    if #references == 0 then
        vim.notify("GDShader: no references found", vim.log.levels.WARN)

        return
    end

    --------------------------------------------------------
    -- Bottom → top
    --
    -- 避免前面的 edit 改变后续 column。
    --------------------------------------------------------

    table.sort(references, function(a, b)
        if a.line ~= b.line then
            return a.line > b.line
        end

        return a.column > b.column
    end)

    local first_edit = true

    for _, reference in ipairs(references) do
        ----------------------------------------------------
        -- 所有 edit 合并成一个 undo step。
        ----------------------------------------------------

        if not first_edit then
            pcall(function()
                vim.cmd("undojoin")
            end)
        end

        vim.api.nvim_buf_set_text(bufnr, reference.line, reference.column, reference.end_line, reference.end_column, {
            new_name,
        })

        first_edit = false
    end

    --------------------------------------------------------
    -- Cursor 回到原 occurrence。
    --------------------------------------------------------

    local range = target.range

    if range then
        local offset = math.max(0, (target.cursor_column or range.start_column) - range.start_column)

        local new_offset = math.min(offset, math.max(0, #new_name - 1))

        pcall(vim.api.nvim_win_set_cursor, 0, {
            range.line + 1,
            range.start_column + new_offset,
        })
    end

    vim.notify(
        "GDShader: renamed " .. target.name .. " → " .. new_name .. " (" .. tostring(#references) .. " occurrences)",
        vim.log.levels.INFO
    )
end

------------------------------------------------------------
-- Rename
------------------------------------------------------------

function M.rename(requested_name)
    local bufnr = vim.api.nvim_get_current_buf()

    if not is_supported(bufnr) then
        return
    end

    local target = current_target(bufnr)

    if not target then
        vim.notify("GDShader: this symbol cannot be renamed", vim.log.levels.INFO)

        return
    end

    --------------------------------------------------------
    -- Command argument
    --------------------------------------------------------

    if requested_name and requested_name ~= "" then
        apply_rename(bufnr, target, requested_name)

        return
    end

    --------------------------------------------------------
    -- Interactive
    --------------------------------------------------------

    vim.ui.input({
        prompt = "Rename " .. target.name .. " to: ",

        default = target.name,
    }, function(new_name)
        if not new_name or new_name == "" then
            return
        end

        ------------------------------------------------
        -- Buffer 可能已经关闭。
        ------------------------------------------------

        if not vim.api.nvim_buf_is_valid(bufnr) then
            return
        end

        apply_rename(bufnr, target, new_name)
    end)
end

------------------------------------------------------------
-- Attach
------------------------------------------------------------

function M.attach(bufnr)
    if not is_supported(bufnr) then
        return
    end

    if vim.b[bufnr].gdshader_blink_rename_attached then
        return
    end

    vim.b[bufnr].gdshader_blink_rename_attached = true

    --------------------------------------------------------
    -- Command
    --
    -- :GDShaderRename
    -- :GDShaderRename new_name
    --------------------------------------------------------

    vim.api.nvim_buf_create_user_command(bufnr, "GDShaderRename", function(opts)
        M.rename(opts.args)
    end, {
        nargs = "?",

        desc = "Rename GDShader symbol",
    })

    vim.keymap.set("n", "<Plug>(gdshader-blink-rename)", function()
        M.rename()
    end, {
        buffer = bufnr,

        silent = true,

        desc = "Rename GDShader symbol",
    })

    --------------------------------------------------------
    -- Neovim 0.11 LSP convention:
    -- grn = rename
    --------------------------------------------------------

    local existing = vim.fn.maparg("grn", "n", false, true)

    if type(existing) ~= "table" or vim.tbl_isempty(existing) then
        vim.keymap.set("n", "grn", function()
            M.rename()
        end, {
            buffer = bufnr,

            silent = true,

            desc = "Rename GDShader symbol",
        })
    end
end

------------------------------------------------------------
-- Setup
------------------------------------------------------------

function M.setup()
    if configured then
        return
    end

    configured = true

    local group = vim.api.nvim_create_augroup("GDShaderBlinkRename", {
        clear = true,
    })

    vim.api.nvim_create_autocmd("FileType", {
        group = group,

        pattern = {
            "gdshader",
            "gdshaderinc",
        },

        callback = function(args)
            M.attach(args.buf)
        end,
    })

    local bufnr = vim.api.nvim_get_current_buf()

    if is_supported(bufnr) then
        M.attach(bufnr)
    end
end

return M
