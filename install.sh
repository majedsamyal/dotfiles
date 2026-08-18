#!/usr/bin/env bash
# Link this repo into $HOME. No sudo. Safe to re-run.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
  local src="$1"
  local dest="$2"

  mkdir -p "$(dirname "$dest")"

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
      echo "ok    $dest"
      return
    fi
    echo "skip  $dest already exists and is not this repo's link"
    echo "      move it aside and re-run ./install.sh"
    return
  fi

  ln -s "$src" "$dest"
  echo "link  $dest -> $src"
}

echo "dotfiles: $ROOT"
link "$ROOT/nvim" "$HOME/.config/nvim"
link "$ROOT/wezterm/wezterm.lua" "$HOME/.wezterm.lua"
link "$ROOT/herdr/config.toml" "$HOME/.config/herdr/config.toml"
link "$ROOT/git/gitconfig" "$HOME/.gitconfig"
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
