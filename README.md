# dotfiles

A complete macOS and desktop Linux workstation: WezTerm, Herdr, Neovim, Git,
Zsh, language tooling, fonts, and supporting command-line utilities.

## Install

Run one command on a new machine:

```bash
git clone https://github.com/majedsamyal/dotfiles ~/dotfiles && ~/dotfiles/install.sh
```

The installer detects the operating system and manages the rest. It only asks
for:

- Git name and email, stored privately in `~/.gitconfig.local`
- One confirmation before backing up conflicting configuration files
- A password when the operating system requires `sudo`

When it finishes, restart the terminal and run `herdr` or `nvim`.

## Options

No options are needed for normal use.

```text
--git-name NAME       Supply the Git name without a prompt
--git-email EMAIL     Supply the Git email without a prompt
--force               Back up and replace conflicting configs
--non-interactive     Disable prompts for automated installs
--no-shell-change     Keep the current login shell
--links-only          Link configs without installing anything
```

An unattended setup looks like this:

```bash
~/dotfiles/install.sh \
  --non-interactive \
  --force \
  --git-name "Your Name" \
  --git-email "you@example.com"
```

`DOTFILES_GIT_NAME` and `DOTFILES_GIT_EMAIL` can be used instead of the two Git
arguments.

## Managed internally

The installer:

1. Detects macOS or Linux.
2. On Linux, installs missing host prerequisites with `apt`, `dnf`, or
   `pacman`.
3. Installs Homebrew when needed and applies the cross-platform `Brewfile`.
4. Installs WezTerm and Hack Nerd Font Mono for the detected platform.
5. Installs Wayland and X11 clipboard support on Linux.
6. Backs up conflicting configs and creates all symlinks.
7. Stores machine-specific Git identity outside the repository.
8. Makes Zsh the login shell unless disabled.
9. Configures the Codex, Kimi, and Grok Herdr integrations.
10. Installs Neovim plugins, language servers, and formatters.
11. Runs `./check.sh` and stops if the workstation is incomplete.

Homebrew provides consistent current tool versions on both operating systems.
Linux WezTerm comes from its official Linuxbrew tap. The supported Linux
package managers are `apt`, `dnf`, and `pacman`; another distribution can use
the same installer after providing Homebrew's base prerequisites.

## Platform behavior

The same WezTerm actions use native modifiers:

| Action           | macOS               | Linux                  |
| ---------------- | ------------------- | ---------------------- |
| Commands         | `Cmd`               | `Ctrl+Shift`           |
| Focus pane       | `Cmd+Shift+H/J/K/L` | `Alt+Shift+H/J/K/L`    |
| Select tab       | `Cmd+1..9`          | `Alt+1..9`             |
| Word movement    | `Option+Arrow`      | `Alt+Arrow`            |
| Open link        | `Cmd+Click`         | `Ctrl+Click`           |

Linux automatically selects Wayland when available and X11 otherwise. Zsh
loads Homebrew from the standard Apple Silicon, Intel Mac, or Linux prefix and
also recognizes common distribution plugin paths.

## Configuration links

| Repository path        | Installed path                  |
| ---------------------- | ------------------------------- |
| `nvim/`                | `~/.config/nvim`                |
| `wezterm/wezterm.lua`  | `~/.wezterm.lua`                |
| `herdr/config.toml`    | `~/.config/herdr/config.toml`   |
| `git/gitconfig`        | `~/.gitconfig`                  |
| `git/gitignore_global` | `~/.gitignore_global`           |
| `zsh/zshrc`            | `~/.zshrc`                      |

Machine-specific shell additions belong in `~/.zshrc.local`. Existing files
replaced with `--force` receive distinct `.bak`, `.bak.1`, and later names.

## Maintenance

```bash
brew update && brew upgrade
```

Use `:Lazy sync` for Neovim plugins and `:MasonToolsUpdate` for language tools.
Run `./check.sh` at any time to verify the complete workstation.
