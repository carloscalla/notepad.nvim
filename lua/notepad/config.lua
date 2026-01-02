local M = {}

---@alias NotepadPosition 'top'|'bottom'|'left'|'right'

---@class NotepadOptions
---@field position? NotepadPosition Default: 'bottom'. Where to open the notepad.
---@field split_size? number Default: nil. Size of the split (percentage or absolute size). nil uses default split behavior

M.global_notepad_name = 'global'

-- Configuration storage
---@type NotepadOptions
M._opts = {
  position = 'bottom',
  split_size = nil,
}

--- Set configuration from init module
---@param opts? NotepadOptions
M.set_opts = function(opts)
  opts = opts or {}

  -- Validate position
  if opts.position then
    local valid_positions = { top = true, bottom = true, left = true, right = true }
    if not valid_positions[opts.position] then
      vim.notify(
        string.format("Invalid position '%s'. Using default 'bottom'. Valid options: top, bottom, left, right", opts.position),
        vim.log.levels.WARN,
        { title = 'Notepad' }
      )
      opts.position = nil -- Use default
    end
  end

  -- Validate split_size
  if opts.split_size ~= nil then
    if type(opts.split_size) ~= 'number' then
      vim.notify(
        string.format("Invalid split_size type '%s'. Must be a number. Using default.", type(opts.split_size)),
        vim.log.levels.WARN,
        { title = 'Notepad' }
      )
      opts.split_size = nil -- Use default
    elseif opts.split_size <= 0 then
      vim.notify('Invalid split_size value. Must be greater than 0. Using default.', vim.log.levels.WARN, { title = 'Notepad' })
      opts.split_size = nil -- Use default
    end
  end

  M._opts = vim.tbl_deep_extend('force', M._opts, opts)
end

return M
