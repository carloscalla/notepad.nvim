local notepad = require 'notepad'

vim.api.nvim_create_user_command('Notepad', function(cmd_args)
  if cmd_args.args == 'global' then
    notepad.open_global()
  else
    notepad.open()
  end
end, {
  desc = 'Open notepad. Use "global" argument to force global notepad',
  nargs = '?',
  complete = function(arg_lead, cmd_line, cursor_pos)
    if arg_lead == '' or string.find('global', '^' .. vim.pesc(arg_lead)) then
      return { 'global' }
    end
    return {}
  end,
})
