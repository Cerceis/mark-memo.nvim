# A floating window for a quick mark reference

## Installation

Use your favorite plugin manager, e.g. with lazy.nvim:

```lua
{
  "Cerceis/mark-memo.nvim",
  config = function()
    require("mark-memo").setup({
      width = 40,
      height = 15,
      border = "rounded",
      position = "topright",
    })
  end
}
```
