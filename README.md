# notepad.nvim

Neovim plugin for taking quick notes

## Installation

Use your favorite package manager to install Notepad, e.g:

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

```vim
:Notepad           " Opens repo-specific notepad (if in git) or global notepad
:Notepad global    " Opens global notepad

```
