# OpenCode LazyVim Plugin

A LazyVim wrapper for opencode.nvim, making installation and configuration easier.

## Screenshots

<img width="1920" height="1200" alt="screenshot-2026-04-26_16-31-28" src="https://github.com/user-attachments/assets/03a0c2ff-b2ed-43b6-9564-7351e754df68" />

## Requirements

- Neovim >= 0.10
- [lazy.nvim](https://github.com/folke/lazy.nvim)
- [opencode.nvim](https://github.com/NickvanDyke/opencode.nvim) (installed automatically as a dependency)

## Installation (LazyVim)

Create `~/.config/nvim/lua/plugins/opencode.lua`:

```lua
-- Local clone (recommended for development):
-- vim.opt.rtp:prepend("/path/to/opencode-lazy.nvim")
-- return require("opencode-lazy")

-- Or from GitHub:
return {
  "jorlly-collado-castro/opencode-lazy.nvim",
  -- uncomment to track main:
  -- branch = "main",
}
```

Restart Neovim and run `:Lazy` to install.

## Keybindings

| Key | Mode | Action |
|---|---|---|
| `<leader>ao` | n, t, v | Toggle OpenCode panel |
| `<C-.>` | n, t, v | Quick toggle OpenCode |
| `<leader>aa` | n, v | Ask with context |
| `<leader>ax` | n, v | Action menu |
| `<leader>ap` | n, v | Add to session |
| `<leader>ai` | n, x | Ask |
| `<leader>aI` | n, x | Ask with context |
| `<leader>ab` | n, x | Ask about buffer |
| `<leader>ape` | n, x | Explain code |
| `<leader>apf` | n, x | Fix code |
| `<leader>apd` | n, x | Diagnose |
| `<leader>apr` | n, x | Review |
| `<leader>apt` | n, x | Generate tests |
| `<leader>apo` | n, x | Optimize |
| `go` | n, x | Add range to session |
| `goo` | n | Add line to session |
| `<S-C-u>` | n | Scroll up (half page) |
| `<S-C-d>` | n | Scroll down (half page) |

## Usage

This little guide will show you how to use this opencode LazyVim plugin.

| Marked Screenshot                                                                                                                                             | Description                                                                                            |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------ |
| <img width="1920" height="1200" alt="screenshot-2026-04-26_16-29-09" src="https://github.com/user-attachments/assets/71554edb-56ef-49de-9d57-f439cd1758aa" /> | Press your leader key (usually `spacebar`). You should see the `+ai` group listed among other entries. |
| <img width="1920" height="1200" alt="screenshot-2026-04-26_16-29-44" src="https://github.com/user-attachments/assets/40bcea20-1b63-4180-bf9c-e6c4aace27e7" /> | Next, press `a`. You should see a list of OpenCode actions.                                            |
| <img width="1920" height="1200" alt="screenshot-2026-04-26_16-30-20" src="https://github.com/user-attachments/assets/efd94b3e-c350-4d35-8026-e5574c3e662b" /> | Finally, press `o` to open OpenCode or any other mapped key to perform that action instead.            |
