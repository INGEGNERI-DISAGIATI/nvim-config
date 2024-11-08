require('ganquan.core.options')
require('ganquan.core.keymaps')
require('ganquan.core.colorschemes')

local core_conf_files = {
  "autocommands.vim", -- various autocommands
  "plugins.vim", -- all the plugins installed and their configurations
}

-- source all the core config files
for _, name in ipairs(core_conf_files) do
  local path = string.format("%s/core/%s", vim.fn.stdpath("config"), name)
  local source_cmd = "source " .. path
  vim.cmd(source_cmd)
end

--vim.cmd("nnoremap <C-I> :w<CR> :echo system('gcc -o nvimoutput ' . expand('%') . ' && ./nvimoutput && rm ./nvimoutput')<CR>")
--vim.cmd("nnoremap <C-I> :w<CR> :!gcc -o nvimoutput % && ./nvimoutput && rm ./nvimoutput<CR>")

--vim.cmd("nnoremap <C-I> :w<CR>:!gcc -o nvimoutput % && stdbuf -o0 ./nvimoutput && rm ./nvimoutput<CR>")
vim.cmd("nnoremap <silent> <C-W>y :let @+ = @0<ENTER>")
vim.cmd("nnoremap <silent> <C-W>k ddp")
vim.cmd("nnoremap <silent> <C-W>j ddkP")

vim.cmd("set whichwrap+=<,>,[,]")

vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        if((vim.bo.filetype == "c") or (vim.bo.filetype == "cpp")) then
            vim.fn.setreg('i',vim.api.nvim_replace_termcodes('<Esc>gg0i#include <stdio.h><CR>#include <stdlib.h><CR>#include <stdbool.h><CR>#include <string.h><CR><CR>int main(void) {<CR><CR>}<Up><Tab><Esc>',true,false,true))
            vim.cmd("nnoremap <C-I> :w<CR>:!gcc -o nvimoutput % $INFINCL/*.c -lm<CR><ENTER>:vert term ./nvimoutput<CR>:!rm ./nvimoutput<CR><ENTER>:startinsert<CR>")
        elseif(vim.bo.filetype == "python") then
            vim.cmd("nnoremap <C-I> :w<CR>:vert term python3 %<CR>:startinsert<CR>")
        end
    end,
})

