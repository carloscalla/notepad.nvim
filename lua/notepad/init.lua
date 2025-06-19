local utils = require 'notepad.utils'

local M = {}

M.setup = function()
  M.open_notepad = function()
    local repo_name
    if utils.is_in_git_dir() then
      repo_name = utils.get_git_repo_name()
      if not repo_name then
        utils.notify('Could not determine the git repository name. Using global notepad', vim.log.levels.ERROR)
      end
    else
      utils.notify('Not inside a git repository. Using global notepad', vim.log.levels.INFO)
    end

    utils.open_notepad_in_split(repo_name)
  end

  vim.api.nvim_create_user_command('Notepad', function()
    M.open_notepad()
  end, { desc = 'Open notepad', nargs = 0 })
end

return M
