# notepad.nvim

Neovim plugin for taking quick notes

<img width="1149" height="655" alt="image" src="https://github.com/user-attachments/assets/c0f825fb-53c6-4815-a29f-2de4d4726e92" />

## Installation & Setup

Use your favorite package manager to install notepad.nvim, e.g:

### Lazy

```lua
{
  "carloscalla/notepad.nvim",
  opts = {}
}
```

Note: You need to call the `setup` function to initialize the plugin. Lazy.nvim does
this with `opts = {}` in the example above.

```lua
require("notepad").setup({
  -- Your configuration here
})
```

### Default Configuration

```lua
require("notepad").setup({
  position = "bottom", -- 'top', 'left', 'right', 'bottom'
  split_size = nil,   -- Size of the split (percentage or absolute size). nil uses default split behavior
})
```

### Setup examples

```lua
-- Top horizontal split
require('notepad').setup({ position = 'top', split_size = 15 })

-- Left vertical split (30% of screen width)
require('notepad').setup({ position = 'left', split_size = 0.3 })

-- Right vertical split (50 columns)
require('notepad').setup({ position = 'right', split_size = 50 })

-- Bottom horizontal split (default)
require('notepad').setup({ position = 'bottom', split_size = 0.25 })
```

## Usage Examples

Use the following commands:

```vim
:Notepad           " Opens repo-specific notepad (if in git) or global notepad
:Notepad global    " Opens global notepad
```

Or with Lua:

```lua
-- Opens repo-specific notepad (if in git) or global notepad
require("notepad").open()

-- Opens global notepad
require("notepad").open_global()
```

## Inspiration

- [vim-bujo](https://github.com/vuciv/vim-bujo)
