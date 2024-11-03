for _,key in ipairs({'q', '<Esc>'}) do
   vim.keymap.set('n', key, ':q<CR>', {buffer=true})
end

vim.api.nvim_create_autocmd('WinLeave', {
   pattern = { 'steno_raw' },
   callback = ':q'
})

vim.wo.virtualedit = 'all'
vim.keymap.set('n', 'q', ':q<CR>', {buffer=true})

vim.opt_local.cursorline = true
vim.opt_local.cursorlineopt = 'line'
vim.api.nvim_set_hl(0, 'CursorLine', {
   fg = '#ffffff',
   bg = 'NONE',
})
