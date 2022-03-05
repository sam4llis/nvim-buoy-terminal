if vim.fn.has('nvim') == 0 then
  return
end


Window = require('nvim-buoy')
Terminal = {}
Terminal.__index = Terminal
setmetatable(Terminal, Window)


function Terminal:open(cmd)
  Window.open(self)

  if not self.pid then
    local cmd = cmd or string.format('%s --login', os.getenv('SHELL'))
    self.pid = vim.fn.termopen(cmd)
  end

  if not vim.fn.has_key(vim.g.plugs, 'nvim-vim-termbinds') then
    vim.cmd('startinsert')
  end

  vim.cmd("autocmd TermClose <buffer> lua require('terminal'):close(true)")
end


function Terminal.run_active_buffer(cmd, save)
  local filename = vim.fn.expand('%')

  if save then
    vim.cmd('write')
  end

  Window.new():open()
  vim.fn.termopen(cmd .. ' ' .. filename)
end


function Terminal.run_repl(cmd)
  t = t or {buf = -1}
  if t.buf == -1 then
    t = Terminal.new({percentage=0.5})
  end
  if not t.win then
    t:open(self, cmd)
    if not t.pid then
      t.pid = vim.fn.termopen(cmd)
    end
  else
    t:close()
  end
end


return Terminal
