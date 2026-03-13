vim.g.mapleader = " "

vim.keymap.set('n', '<leader>wh', '<C-w>h', { noremap = true })
vim.keymap.set('n', '<leader>wl', '<C-w>l', { noremap = true })
vim.keymap.set('n', '<leader>wj', '<C-w>j', { noremap = true })
vim.keymap.set('n', '<leader>wk', '<C-w>k', { noremap = true })

local function relative_buf_path()
    local name = vim.api.nvim_buf_get_name(0)
    if name == "" then
        return "[No Name]"
    end
    return vim.fn.fnamemodify(name, ":.")
end

local function copy_location(range)
    local file = relative_buf_path()
    local text
    local selection = nil

    if range then
        -- Use live visual endpoints so this works in charwise/linewise/blockwise visual modes.
        local start_line = vim.fn.getpos("v")[2]
        local end_line = vim.fn.line(".")
        selection = { start_line, end_line }
        if start_line > end_line then
            start_line, end_line = end_line, start_line
        end
        if start_line == end_line then
            text = string.format("%s:%d", file, start_line)
        else
            text = string.format("%s:%d-%d", file, start_line, end_line)
        end
    else
        text = string.format("%s:%d", file, vim.api.nvim_win_get_cursor(0)[1])
    end

    vim.fn.setreg('"', text)
    pcall(vim.fn.setreg, "+", text)

    if selection then
        vim.api.nvim_feedkeys(
            vim.api.nvim_replace_termcodes("<Esc>", true, false, true),
            "nx",
            false
        )
    end

    vim.notify("Copied: " .. text)
end

vim.keymap.set('n', '<leader>yl', function()
    copy_location(false)
end, { desc = "Copy file:line" })

vim.keymap.set('v', '<leader>yl', function()
    copy_location(true)
end, { desc = "Copy file:start-end" })
