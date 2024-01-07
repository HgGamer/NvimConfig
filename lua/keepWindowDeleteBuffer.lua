local keepWindowDeleteBuffer = {}

-- Helper function to check if a buffer is listed
local function is_buf_listed(buf)
    return vim.fn.buflisted(buf) == 1
end

-- Helper function to check if a buffer exists
local function buf_exists(buf)
    return vim.fn.bufexists(buf) == 1
end

function getBufferNumber()
    local kwbdBufNum = vim.fn.bufnr("%")

    local buflistedLeft = 0
    local bufFinalJump = 0
    local nBufs = vim.fn.bufnr("$")

    for i = 1, nBufs do
        if i ~= kwbdBufNum then
            if is_buf_listed(i) then
                buflistedLeft = buflistedLeft + 1
            elseif buf_exists(i) and vim.fn.strlen(vim.fn.bufname(i)) == 0 and bufFinalJump == 0 then
                bufFinalJump = i
            end
        end
    end

    return buflistedLeft;
end

-- keepWindowDeleteBuffe mrain function
function keepWindowDeleteBuffer.kwbd(kwbdStage)
    if getBufferNumber() >= 1 then
        vim.cmd("b#")
        vim.cmd("bd!#")
    else
        vim.cmd("enew")
        if getBufferNumber() == 1 then
            vim.cmd("bd!#")
        end
    end
end

-- Setup function for the plugin
function keepWindowDeleteBuffer.setup()
    vim.api.nvim_set_keymap('n', '<Plug>kwbd', ":lua require'keepWindowDeleteBuffer'.kwbd(1)<CR>", { noremap = true, silent = true })
    vim.api.nvim_create_user_command('Kwbd', "lua require'keepWindowDeleteBuffer'.kwbd(1)", {desc = "Keep Window, Delete Buffer"})
end

return keepWindowDeleteBuffer