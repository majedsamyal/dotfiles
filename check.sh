#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ok() {
  printf "ok    %s\n" "$1"
}

warn() {
  printf "warn  %s\n" "$1"
}

need() {
  if command -v "$1" >/dev/null 2>&1; then
    ok "$1"
  else
    warn "$1 missing"
  fi
}

linked() {
  local src="$ROOT/$1"
  local dest="$2"
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    ok "$dest"
  else
    warn "$dest not linked to this repo - run ./install.sh"
  fi
}

echo "== links =="
linked "nvim" "$HOME/.config/nvim"
linked "wezterm/wezterm.lua" "$HOME/.wezterm.lua"
linked "herdr/config.toml" "$HOME/.config/herdr/config.toml"
linked "git/gitconfig" "$HOME/.gitconfig"
linked "git/gitignore_global" "$HOME/.gitignore_global"
linked "zsh/zshrc" "$HOME/.zshrc"

echo ""
echo "== tools =="
need git
need nvim
need rg
need node
need stylua
need fzf
need zoxide
need lazygit
need herdr

if command -v wezterm >/dev/null 2>&1 || [ -x /Applications/WezTerm.app/Contents/MacOS/wezterm ]; then
  ok wezterm
else
  warn "wezterm missing"
fi

echo ""
echo "== neovim =="
if command -v nvim >/dev/null 2>&1; then
  runtime_dir="${TMPDIR:-/tmp}/dotfiles-nvim-runtime"
  mkdir -p "$runtime_dir"
  XDG_RUNTIME_DIR="$runtime_dir" NVIM_LOG_FILE="$runtime_dir/nvim.log" nvim --headless --cmd "set shadafile=NONE" "+lua print('nvim ' .. tostring(vim.g.colors_name or 'no theme'))" "+qa"
  printf "\n"
fi

echo "== herdr =="
if command -v herdr >/dev/null 2>&1; then
  HERDR_CONFIG_PATH="$ROOT/herdr/config.toml" herdr config check
  herdr integration status | grep -E "codex|kimi|grok" || true
fi
