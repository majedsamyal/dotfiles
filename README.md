# dotfiles

My simple setup for Neovim WezTerm and Herdr.

This repo is small and easy to read.
It is made for a fresh Neovim setup.
It only links files to your home folder.
It does not install system tools.
It does not use private path.

## what you need

Neovim 0.12 or newer
WezTerm
Herdr
Git
ripgrep
C compiler
Hack Nerd Font

## install tools on mac

With Homebrew you can install some tools.

```bash
brew install neovim git ripgrep
```

Install WezTerm from WezTerm website.

Install Herdr from Herdr website.

Install Hack Nerd Font from Nerd Fonts website.

## install

```bash
git clone <your repo url> ~/dotfiles
cd ~/dotfiles
./install.sh
nvim
```

First Neovim start will download plugins.
After that it will use local plugin cache.

## what files are used

`nvim` goes to `~/.config/nvim`

`wezterm/wezterm.lua` goes to `~/.wezterm.lua`

`herdr/config.toml` goes to `~/.config/herdr/config.toml`

`git/gitconfig` goes to `~/.gitconfig`

`zsh/zshrc` goes to `~/.zshrc`

## theme

Theme is Catppuccin Mocha.
Neovim WezTerm and Herdr use same theme.

## Neovim

This is not a big framework.
It is normal Lua config with lazy.nvim.

Main file is `nvim/init.lua`

Config files are in `nvim/lua/config`

Plugin files are in `nvim/lua/plugins`

## Neovim features

Catppuccin Mocha theme
Treesitter
LSP with Mason
Format with conform
File picker with Snap
File explorer with Oil
Fast file marks with Grapple
Git signs
Status line
Dashboard
Centered command box
Completion
Auto pairs
Surround
Diagnostics list

## languages

Python
Lua
Bash
JSON
TypeScript
JavaScript
Go
Rust
Docker
YAML
Terraform
Markdown
TOML

## Neovim health

Inside Neovim run checkhealth.

Open Lazy to see plugins.

Open Mason to see language servers.

Open TSInstallInfo to see Treesitter parsers.

## useful keys

`n` new file from dashboard

`f` find file from dashboard

`g` grep from dashboard

`<leader>ff` find files

`<leader>fg` grep text

`<leader>fb` buffers

`<leader>fo` old files

`<leader>e` file explorer

`<leader>fp` show current file path

`<leader>m` mark current file with Grapple

`<leader>M` show Grapple files

`<leader>1` to `<leader>4` open marked files

`<leader>n` next marked file

`<leader>p` previous marked file

`<leader>fm` format file

## WezTerm

WezTerm uses Hack Nerd Font.
Font size is 16.
Font weight is regular.
Theme is Catppuccin Mocha.

## Herdr

Herdr uses Catppuccin.
It uses same pink accent from Catppuccin Mocha.
It does not use private shell path.
Install script also sets Herdr hooks for Codex Kimi and Grok.

## Git

Git config has aliases and Neovim as editor.
It does not include name or email.
Set those on each machine.

## Zsh

Zsh config is small.
It sets Neovim as editor.
It adds local bin to PATH.
It adds a few aliases.

## check

Run this after install.

```bash
./check.sh
```

## note

Keep this repo clean.
Do not add local machine path.
Do not add private name.
Keep config simple.
