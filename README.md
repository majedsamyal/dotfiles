# dotfiles

My Mac setup: Neovim, WezTerm, Herdr, Git, and Zsh.
Everything is symlinked from this repo, so edits here apply everywhere.

## Setting up a new machine

Clone the repo and run the installer:

```bash
git clone https://github.com/majedsamyal/dotfiles ~/dotfiles
cd ~/dotfiles
./install.sh --brew
```

`--brew` runs `brew bundle` and installs every tool the setup needs
(WezTerm, Neovim, fonts, fzf, zoxide, lazygit, and friends).
If you already have the tools, plain `./install.sh` just links the configs.

Then open Neovim once — the first start downloads all plugins:

```bash
nvim
```

Run `./check.sh` afterwards. It verifies the symlinks and tells you
if anything is missing.

## What goes where

| File in repo           | Linked to                       |
| ---------------------- | ------------------------------- |
| `nvim/`                | `~/.config/nvim`                |
| `wezterm/wezterm.lua`  | `~/.wezterm.lua`                |
| `herdr/config.toml`    | `~/.config/herdr/config.toml`   |
| `git/gitconfig`        | `~/.gitconfig`                  |
| `git/gitignore_global` | `~/.gitignore_global`           |
| `zsh/zshrc`            | `~/.zshrc`                      |

## Existing files

The installer never overwrites your files. If something already exists
it skips it and tells you. To replace it anyway, run:

```bash
./install.sh --force
```

Your old file is kept as a `.bak`, so nothing is lost.

## Git identity per machine

The shared `gitconfig` deliberately has no name or email. Set your
identity per machine or per directory instead:

```bash
git config --global user.name "Your Name"
git config --global user.email "you@personal.com"
```

If you keep work and personal code in separate folders, let Git pick
the right identity automatically:

```gitconfig
# in ~/.gitconfig.local (not tracked by this repo)
[includeIf "gitdir:~/work/"]
  path = ~/.gitconfig-work
```

Put `user.email = you@company.com` in `~/.gitconfig-work` and you can
never commit to a work repo with your personal address.

## Shell notes

The zsh setup expects a few brew-installed plugins, all in the Brewfile:

- `zsh-autosuggestions` — completes from your history as you type
- `zsh-syntax-highlighting` — commands turn red when they don't exist
- `fzf` — `Ctrl-R` for fuzzy history, `Ctrl-T` for fuzzy file pick
- `zoxide` — `z foo` jumps to directories you visit often

If any of them are missing the shell still works, just without that feature.

Machine-specific things (Java paths, work VPN hosts, employer aliases)
do not belong in this repo. Put them in `~/.zshrc.local` — the zshrc
sources it automatically if it exists.

The prompt is [Starship](https://starship.rs), initialized from
`~/.zshrc.local`. Its config lives at `~/.config/starship.toml`.

## Herdr

Herdr is not on Homebrew, so install it separately. Once it's on your
PATH, `install.sh` wires up its codex, kimi, and grok integrations
automatically.
