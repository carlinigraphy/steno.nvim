vim.wo.virtualedit = 'all'
vim.keymap.set('n', 'q', ':q<CR>', {buffer=true})

vim.api.nvim_create_autocmd('WinLeave', {
   pattern = { 'steno_raw' },
   callback = ':q'
})
