vim.api.nvim_create_autocmd({'BufRead', 'BufNewFile'}, {
   pattern = { '**/steno/**/*.txt', '*.steno_r', '*.steno_raw' },
   callback = function()
      vim.opt_local.filetype = 'steno_raw'
   end
})
