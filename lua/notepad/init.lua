local config = require 'notepad.config'
local utils = require 'notepad.utils'

local M = {}

---@param force_global boolean
local open_notepad = function(force_global)
  local repo_name

  if force_global then
    utils.notify('Opening global notepad', vim.log.levels.INFO)
    repo_name = nil -- This will use global notepad
  else
    if utils.is_in_git_dir() then
      repo_name = utils.get_git_repo_name()
      if not repo_name then
        utils.notify('Could not determine the git repository name. Using global notepad', vim.log.levels.ERROR)
      end
    else
      utils.notify('Not inside a git repository. Using global notepad', vim.log.levels.INFO)
    end
  end

  utils.open_notepad_in_split(repo_name)
end

M.setup = function(opts)
  -- Merge user options with defaults
  config.set_opts(opts)

  M.open = function()
    open_notepad(false)
  end

  M.open_global = function()
    open_notepad(true)
  end

  vim.api.nvim_create_user_command('Notepad', function(cmd_args)
    local force_global = cmd_args.args == 'global'
    open_notepad(force_global)
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
end

return M
