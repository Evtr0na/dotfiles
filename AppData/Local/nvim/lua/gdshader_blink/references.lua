local M = {}

local semantic_references = require("gdshader_blink.semantic.references")

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
-- Current target
------------------------------------------------------------

local function current_target(bufnr)
    local cursor = vim.api.nvim_win_get_cursor(0)

    return semantic_references.target_at(bufnr, cursor[1] - 1, cursor[2])
end

------------------------------------------------------------
-- Show
------------------------------------------------------------

function M.show()
    local bufnr = vim.api.nvim_get_current_buf()

    if not is_supported(bufnr) then
        return
    end

    local target = current_target(bufnr)

    if not target then
        vim.notify("GDShader: no renameable symbol under cursor", vim.log.levels.INFO)

        return
    end

    local references = semantic_references.find(bufnr, target)

    if #references == 0 then
        vim.notify("GDShader: no references found for " .. target.name, vim.log.levels.INFO)

        return
    end

    local items = {}

    for _, reference in ipairs(references) do
        local text = reference.text:gsub("^%s+", ""):gsub("%s+$", "")

        table.insert(items, {
            bufnr = bufnr,

            lnum = reference.line + 1,

            col = reference.column + 1,

            text = (reference.declaration and "[declaration] " or "") .. text,
        })
    end

    vim.fn.setqflist({}, " ", {
        title = "GDShader references: " .. target.name,

        items = items,
    })

    pcall(function()
        vim.cmd("copen")
    end)
end

------------------------------------------------------------
-- Attach
------------------------------------------------------------

function M.attach(bufnr)
    if not is_supported(bufnr) then
        return
    end

    if vim.b[bufnr].gdshader_blink_references_attached then
        return
    end

    vim.b[bufnr].gdshader_blink_references_attached = true

    vim.api.nvim_buf_create_user_command(bufnr, "GDShaderReferences", function()
        M.show()
    end, {
        desc = "Find GDShader references",
    })

    vim.keymap.set("n", "<Plug>(gdshader-blink-references)", M.show, {
        buffer = bufnr,

        silent = true,

        desc = "GDShader references",
    })

    --------------------------------------------------------
    -- Neovim 0.11 LSP convention:
    -- grr = references
    --
    -- 只在没有已有 mapping 时设置。
    --------------------------------------------------------

    local existing = vim.fn.maparg("grr", "n", false, true)

    if type(existing) ~= "table" or vim.tbl_isempty(existing) then
        vim.keymap.set("n", "grr", M.show, {
            buffer = bufnr,

            silent = true,

            desc = "GDShader references",
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

    local group = vim.api.nvim_create_augroup("GDShaderBlinkReferences", {
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
