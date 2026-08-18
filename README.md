# dotfiles

My setup for Neovim WezTerm Herdr Git and Zsh.

This repo does not install apps.
Install the tools first.
Then use this repo for config files.

## need

Neovim 0.12 or newer
WezTerm
Herdr
Git
ripgrep
C compiler
Hack Nerd Font

## install

Clone this repo.

```bash
git clone https://github.com/majedsamyal/dotfiles ~/dotfiles
cd ~/dotfiles
./install.sh
```

Open Neovim.

```bash
nvim
```

First Neovim start will download plugins.

## linked files

`nvim` goes to `~/.config/nvim`

`wezterm/wezterm.lua` goes to `~/.wezterm.lua`

`herdr/config.toml` goes to `~/.config/herdr/config.toml`

`git/gitconfig` goes to `~/.gitconfig`

`zsh/zshrc` goes to `~/.zshrc`

## check

Run this after install.

```bash
./check.sh
```

## important

If you already have one of these files the install script will not replace it.
Move your old file first and run install again.
