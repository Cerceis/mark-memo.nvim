# A floating window for a quick mark reference

## Installation

Use your favorite plugin manager, e.g. with lazy.nvim:

```lua
{
  "Cerceis/mark-memo.nvim",
  config = function()
    require("mark-memo").setup({
      width = 15,
      height = 5,
      border = "rounded",
      position = "topright",
    })
  end
}
```
