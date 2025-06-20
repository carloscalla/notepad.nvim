# notepad.nvim

Neovim plugin for taking quick notes

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

## 📝 Usage Examples

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
