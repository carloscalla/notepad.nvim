local M = {}

---@param msg string
---@param level? vim.log.levels
M.notify = function(msg, level)
  vim.schedule(function()
    vim.notify(msg, level or vim.log.levels.INFO, { title = 'Notepad' })
  end)
end

M.is_in_git_dir = function()
  local cmd = { 'git', 'rev-parse', '--is-inside-work-tree' }
  local result = vim.system(cmd):wait()

  return result.code == 0 and result.stdout:gsub('%s+', '') == 'true'
end

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

M.open_notepad = function(repository_name)
  local root = os.getenv 'HOME' or os.getenv 'USERPROFILE'
  local notepad_dir = root .. '/.cache/notepad.nvim/' --[[ .. (repository_name or 'global') .. '.md' ]]

  if vim.fn.isdirectory(notepad_dir) == 0 then
    local ok, err = pcall(vim.fn.mkdir, notepad_dir, 'p')
    if not ok then
      M.notify('Error creating notepad directory: ' .. err, vim.log.levels.ERROR)
      return
    end
  end

  local notepad_file = notepad_dir .. (repository_name or 'global') .. '.md'

  -- create file and open it
  if not vim.uv.fs_stat(notepad_file) then
    local fd = vim.uv.fs_open(notepad_file, 'a', 420)
    if fd then
      vim.uv.fs_close(fd)
    end
  end

  -- vim.api.nvim_command('edit ' .. notepad_file)

  -- Open the file in a floating window
  local notepad_path = vim.fn.fnameescape(notepad_file)
  local win = vim.api.nvim_open_win(0, true, {
    relative = 'editor',
    width = math.floor(vim.o.columns * 0.8),
    height = math.floor(vim.o.lines * 0.8),
    row = math.floor((vim.o.lines - vim.o.lines * 0.8) / 2),
    col = math.floor((vim.o.columns - vim.o.columns * 0.8) / 2),
    style = 'minimal',
    border = 'single',
    title = 'Notepad',
    title_pos = 'center',
  })
  -- vim.api.nvim_win_set_buf(win, vim.api.nvim_create_buf(true, false))
  vim.cmd('edit ' .. notepad_path)
end

return M
