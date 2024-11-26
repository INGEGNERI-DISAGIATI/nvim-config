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
            vim.cmd("nnoremap <C-I> :wa<CR>:!gcc -o nvimoutput % $INFINCL/*.c -lm<CR><ENTER>:vert term ./nvimoutput<CR>:!rm ./nvimoutput<CR><ENTER>:startinsert<CR>")
            vim.cmd("nnoremap <C-W>e :wa<CR>:!gcc -o nvimoutput *.c -lm<CR><ENTER>:vert term ./nvimoutput<CR>:!rm ./nvimoutput<CR><ENTER>:startinsert<CR>")
            vim.cmd("nnoremap <C-W>r :wa<CR>:!gcc -o nvimoutput % -lm<CR><ENTER>:vert term ./nvimoutput<CR>:!rm ./nvimoutput<CR><ENTER>:startinsert<CR>")
        elseif(vim.bo.filetype == "python") then
            vim.cmd("nnoremap <C-I> :wa<CR>:vert term python3 %<CR>:startinsert<CR>")
        elseif(vim.bo.filetype == "rust") then
            vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
                command = "w",
                buffer = 0,
                nested = true
            })
            vim.cmd("nnoremap <C-I> :wa<CR>:vert term cargo run<CR>:startinsert<CR>")
        end
    end,
})
vim.api.nvim_create_autocmd("LspAttach", {
  pattern = "*.java",  -- Trigger for any filetype
  callback = function()
    --vim.fn.setreg('a', "ok")  -- Set the first workspace folder to register 'a'
    -- Check if the attached LSP client is jdtls (Java LSP)
    local clients = vim.lsp.get_active_clients()
    for _, client in ipairs(clients) do
      if client.name == 'jdtls' then
        -- Get the list of workspace folders
        local workspace_folders = vim.lsp.buf.list_workspace_folders()

        -- If there are workspace folders, set the first one to register 'a'
        if workspace_folders and #workspace_folders > 0 then
          local workspace_root = workspace_folders[1]
          vim.fn.setreg('a', workspace_root)  -- Set the first workspace folder to register 'a'
          local runString = "nnoremap <C-I> :wa<CR>:vert term mvn -f WORKSPACE/pom.xml -q compile exec:java<CR>:startinsert<CR>"
          local newRunString = runString:gsub("WORKSPACE",workspace_root)
          vim.cmd(newRunString)
        end
        break
      end
    end
  end,
})

