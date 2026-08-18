#!/usr/bin/env bash
# Link this repo into $HOME. No sudo. Safe to re-run.
#
#   ./install.sh            link configs, skip anything that already exists
#   ./install.sh --force    back up existing files to *.bak and replace them
#   ./install.sh --brew     also run `brew bundle` to install the tools
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

FORCE=0
BREW=0
for arg in "$@"; do
  case "$arg" in
    --force) FORCE=1 ;;
    --brew) BREW=1 ;;
    *) echo "unknown option: $arg" >&2; exit 1 ;;
  esac
done

if [ "$BREW" -eq 1 ]; then
  if command -v brew >/dev/null 2>&1; then
    brew bundle --file="$ROOT/Brewfile"
  else
    echo "skip  brew bundle because brew is not on PATH"
  fi
fi

link() {
  local src="$1"
  local dest="$2"

  mkdir -p "$(dirname "$dest")"

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
      echo "ok    $dest"
      return
    fi
    if [ "$FORCE" -eq 1 ]; then
      mv "$dest" "$dest.bak"
      echo "bak   $dest -> $dest.bak"
    else
      echo "skip  $dest already exists and is not this repo's link"
      echo "      move it aside or re-run with --force"
      return
    fi
  fi

  ln -s "$src" "$dest"
  echo "link  $dest -> $src"
}

echo "dotfiles: $ROOT"
link "$ROOT/nvim" "$HOME/.config/nvim"
link "$ROOT/wezterm/wezterm.lua" "$HOME/.wezterm.lua"
link "$ROOT/herdr/config.toml" "$HOME/.config/herdr/config.toml"
link "$ROOT/git/gitconfig" "$HOME/.gitconfig"
link "$ROOT/git/gitignore_global" "$HOME/.gitignore_global"
link "$ROOT/zsh/zshrc" "$HOME/.zshrc"

HERDR_BIN="$(command -v herdr || true)"
if [ -n "$HERDR_BIN" ]; then
  "$HERDR_BIN" integration install codex || true
  "$HERDR_BIN" integration install kimi || true
  "$HERDR_BIN" integration install grok || true
else
  echo "skip  herdr integrations because herdr is not on PATH"
fi

echo "done"
