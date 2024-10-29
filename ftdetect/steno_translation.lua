vim.api.nvim_create_autocmd({'BufRead', 'BufNewFile'}, {
   pattern = { '*.steno_t', '*.steno_translation' },
   callback = 'setlocal filetype=steno_translation'
})
