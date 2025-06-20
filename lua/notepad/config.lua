local M = {}

M.global_notepad_name = 'global'

-- Configuration storage
M._opts = {
  position = 'bottom', -- 'bottom', 'top', 'left', 'right'
  split_size = nil, -- nil means use default split behavior
}

--- Set configuration from init module
---@param opts table Configuration options
M.set_opts = function(opts)
  M._opts = vim.tbl_deep_extend('force', M._opts, opts or {})
end

return M
