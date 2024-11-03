vim.api.nvim_create_autocmd({'BufRead', 'BufNewFile'}, {
   pattern = { '*.steno_t', '*.steno_translation' },
   callback = function()
      vim.opt_local.filetype = 'steno_translation'
   end
})
