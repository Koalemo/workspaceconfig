-- init.lua (or lua/config/diagnostics.lua required from init.lua)
vim.diagnostic.config({
  virtual_text = {
    format = function(diagnostic)
      return string.format('[%s] %s', diagnostic.source or '?', diagnostic.message)
    end,
  },
})
vim.api.nvim_create_autocmd('DiagnosticChanged', {
  callback = function()
    vim.diagnostic.setqflist({
      namespace = require('lint').get_namespace('fusesoc_verilator'),
      open = false, -- don't steal focus / auto-open the window
    })
  end,
})
