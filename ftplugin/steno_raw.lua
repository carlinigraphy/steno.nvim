vim.opt_local.number         = false
vim.opt_local.relativenumber = false
vim.opt_local.autoindent     = false
vim.opt_local.smartindent    = false
vim.opt_local.textwidth      = 60
vim.opt_local.scrollbind     = true
vim.opt_local.list           = true
vim.opt_local.listchars      = { space='─' }
vim.api.nvim_set_hl(0, 'NonText', { fg='#202020' })

vim.keymap.set('n', 'K', function()
   require('steno').query()
end, { desc = "Provide raw steno suggestions" })
