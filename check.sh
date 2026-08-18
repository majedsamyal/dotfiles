#!/usr/bin/env bash
set -euo pipefail

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

need git
need nvim
need rg
need herdr

if command -v wezterm >/dev/null 2>&1 || [ -x /Applications/WezTerm.app/Contents/MacOS/wezterm ]; then
  ok wezterm
else
  warn "wezterm missing"
fi

if command -v nvim >/dev/null 2>&1; then
  runtime_dir="${TMPDIR:-/tmp}/dotfiles-nvim-runtime"
  mkdir -p "$runtime_dir"
  XDG_RUNTIME_DIR="$runtime_dir" NVIM_LOG_FILE="$runtime_dir/nvim.log" nvim --headless --cmd "set shadafile=NONE" "+lua print('nvim ' .. tostring(vim.g.colors_name or 'no theme'))" "+qa"
  printf "\n"
fi

if command -v herdr >/dev/null 2>&1; then
  HERDR_CONFIG_PATH="$PWD/herdr/config.toml" herdr config check
  herdr integration status | grep -E "codex|kimi|grok" || true
fi
