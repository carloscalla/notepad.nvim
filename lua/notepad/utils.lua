local config = require 'notepad.config'

local M = {}

---@param msg string
---@param level? vim.log.levels
M.notify = function(msg, level)
  vim.schedule(function()
    vim.notify(msg, level or vim.log.levels.INFO, { title = 'Notepad' })
  end)
end

--- Check if the current directory is inside a git repository
---@return boolean
M.is_in_git_dir = function()
  local cmd = { 'git', 'rev-parse', '--is-inside-work-tree' }
  local result = vim.system(cmd):wait()

  return result.code == 0 and result.stdout:gsub('%s+', '') == 'true'
end

--- Get the name of the current git repository
---@return string|nil
M.get_git_repo_name = function()
  local cmd = { 'git', 'config', '--get', 'remote.origin.url' }
  local result = vim.system(cmd):wait()

  if result.code ~= 0 then
    return nil
  end

  local repo_url = result.stdout:gsub('%s+', '')
  local repo_name = repo_url:match '([^/]+)%.git$' or repo_url:match '([^/]+)$'

  return repo_name
end

--- Get the path to the notepad file
---@param name string|nil The name of the notepad file. If nil, uses the global notepad name.
---@return string The full path to the notepad file
M.get_notepad_path = function(name)
  local root = os.getenv 'HOME' or os.getenv 'USERPROFILE' or '~'
  local notepad_dir = root .. '/.cache/notepad.nvim/'

  if not name or name == '' then
    name = config.global_notepad_name
  end

  return vim.fn.expand(notepad_dir .. name .. '.md')
end

---Open a file in a horizontal split, creating it if it doesn't exist
---@param repo_name string|nil The name of the file (without extension) to open
M.open_notepad_in_split = function(repo_name)
  local notepad_path = M.get_notepad_path(repo_name)
  local notepad_dir = vim.fn.fnamemodify(notepad_path, ':h')

  -- Create directory if it doesn't exist
  if vim.fn.isdirectory(notepad_dir) == 0 then
    local ok, err = pcall(vim.fn.mkdir, notepad_dir, 'p')
    if not ok then
      M.notify('Error creating notepad directory: ' .. err, vim.log.levels.ERROR)
      return
    end
  end

  -- Create file if it doesn't exist
  if not vim.uv.fs_stat(notepad_path) then
    local fd = vim.uv.fs_open(notepad_path, 'w', 420)
    if fd then
      -- Write header based on repo name
      local header_content
      if repo_name then
        header_content = '# Repository: ' .. repo_name .. '\n\n'
      else
        header_content = '# Global Notepad\n\n'
      end

      vim.uv.fs_write(fd, header_content)
      vim.uv.fs_close(fd)
    else
      M.notify('Error creating notepad', vim.log.levels.ERROR)
      return
    end
  end

  -- Open the file in a horizontal split
  local escaped_path = vim.fn.fnameescape(notepad_path)

  -- Determine split command based on configuration
  local split_cmd
  local position = config._opts.position or 'bottom'

  -- Determine position prefix and split type
  local position_prefix = ''
  local split_type = 'split'

  if position == 'top' then
    position_prefix = 'topleft '
    split_type = 'split'
  elseif position == 'bottom' then
    position_prefix = 'botright '
    split_type = 'split'
  elseif position == 'left' then
    position_prefix = 'leftabove '
    split_type = 'vsplit'
  elseif position == 'right' then
    position_prefix = 'rightbelow '
    split_type = 'vsplit'
  else
    -- Default to bottom if invalid position
    position_prefix = 'botright '
    split_type = 'split'
  end

  if config._opts.split_size then
    if type(config._opts.split_size) == 'number' then
      if config._opts.split_size > 0 and config._opts.split_size < 1 then
        -- Percentage of window height/width
        local size
        if split_type == 'vsplit' then
          size = math.floor(vim.o.columns * config._opts.split_size)
        else
          size = math.floor(vim.o.lines * config._opts.split_size)
        end
        split_cmd = position_prefix .. size .. split_type .. ' ' .. escaped_path
      else
        -- Absolute size in lines/columns
        split_cmd = position_prefix .. config._opts.split_size .. split_type .. ' ' .. escaped_path
      end
    else
      -- Invalid type, use default
      split_cmd = position_prefix .. split_type .. ' ' .. escaped_path
    end
  else
    -- Default behavior
    split_cmd = position_prefix .. split_type .. ' ' .. escaped_path
  end

  vim.cmd(split_cmd)
end

return M
