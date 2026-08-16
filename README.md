# dotfiles

Portable editor and terminal config. Clone it, run `./install.sh`, done.

Works on a personal Mac and on a locked-down Linux desktop. The install script only writes into `$HOME`. No sudo, no Nix, no Homebrew wipe.

## What is in here

| Path | Linked to |
|---|---|
| `nvim/` | `~/.config/nvim` |
| `wezterm/wezterm.lua` | `~/.wezterm.lua` |
| `herdr/` | optional; only used if Herdr is installed |

Neovim is a small [lazy.nvim](https://github.com/folke/lazy.nvim) setup, not NvChad. Every file is yours.

## New machine

1. Install Neovim however that machine allows (`brew install neovim`, `apt install neovim`, or [mise](https://mise.jdx.dev)).
2. Clone this repo.
3. Run the installer.

```bash
git clone <your-remote> ~/dotfiles
cd ~/dotfiles
./install.sh
nvim
```

The first `nvim` launch downloads plugins. After that it works offline.

## This machine

`./install.sh` already linked the folders. Edit files **in this repo**. The links in `$HOME` follow automatically.

## Backup of the old NvChad config

The previous Neovim config was moved out of the way, not deleted:

```text
~/.dotfiles-backup/20260816/
```

## Later

Add zsh, git, or Linux-only files here when you want them. Keep machine-specific paths out of the shared files (use `$HOME`, not `/Users/you`).
