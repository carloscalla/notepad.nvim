local config = require 'notepad.config'
local utils = require 'notepad.utils'

local M = {}

---@param force_global boolean If true, always opens global notepad
local open_notepad = function(force_global)
  local repo_name = nil -- This will use global notepad

  if force_global then
    utils.notify('Opening global notepad', vim.log.levels.INFO)
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

--- Open notepad (repo-specific if in git, otherwise global)
M.open = function()
  open_notepad(false)
end

--- Open global notepad
M.open_global = function()
  open_notepad(true)
end

--- Setup notepad plugin with user configuration
---@param opts? NotepadOptions
M.setup = function(opts)
  -- Merge user options with defaults
  config.set_opts(opts)
end

return M
