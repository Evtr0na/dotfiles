------------------------------------------------------------
--  Messages
------------------------------------------------------------

vim.api.nvim_create_user_command("Msg", function(opts)
    local msg = vim.fn.execute("messages")
    if opts.args == "y" or opts.args == "copy" then
        vim.fn.setreg("+", msg)
        print("Messages copied to clipboard")
    else
        vim.cmd("vnew")
        local lines = vim.split(msg, "\n")
        vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
        vim.cmd("normal! G")
    end
end, {
    nargs = "?",
    complete = function()
        return { "y", "copy" }
    end,
    desc = "Show messages in split or copy to clipboard",
})

--Readme
--":Msg":open a buffer of messages
--":Msy y":just to yank
--":Msy copy":similar to ":Msy"
