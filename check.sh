#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS="$(uname -s)"
WARNINGS=0

ok() {
  printf "ok    %s\n" "$1"
}

warn() {
  printf "warn  %s\n" "$1"
  WARNINGS=$((WARNINGS + 1))
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

echo "== platform =="
case "$OS" in
  Darwin) ok "macOS" ;;
  Linux) ok "Linux" ;;
  *) warn "unsupported operating system: $OS" ;;
esac

if command -v brew >/dev/null 2>&1; then
  ok "Homebrew $(brew --version | head -n 1)"
else
  warn "Homebrew missing - package installation uses Homebrew on both platforms"
fi

if [ "${DOTFILES_ALLOW_NON_ZSH:-0}" = "1" ]; then
  ok "login shell check disabled"
elif [ "${SHELL:-}" != "" ] && [ "${SHELL##*/}" = "zsh" ]; then
  ok "login shell is zsh"
else
  warn "login shell is not zsh (current: ${SHELL:-unknown})"
fi

echo ""
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
need npm
need go
need python3
need rustfmt
need terraform
need stylua
need fzf
need zoxide
need eza
need bat
need starship
need lazygit
need herdr
need zsh
need curl
need unzip
need cc

WEZTERM_BIN="$(command -v wezterm || true)"
if [ -z "$WEZTERM_BIN" ] && [ -x /Applications/WezTerm.app/Contents/MacOS/wezterm ]; then
  WEZTERM_BIN=/Applications/WezTerm.app/Contents/MacOS/wezterm
fi

if [ -n "$WEZTERM_BIN" ]; then
  ok wezterm
else
  warn "wezterm missing"
fi

if [ "$OS" = "Linux" ]; then
  if command -v wl-copy >/dev/null 2>&1 || command -v xclip >/dev/null 2>&1 || command -v xsel >/dev/null 2>&1; then
    ok "Neovim clipboard provider"
  else
    warn "clipboard provider missing (install wl-clipboard or xclip)"
  fi
fi

font_found=0
if command -v fc-match >/dev/null 2>&1 \
  && fc-match -f '%{family}\n' "Hack Nerd Font Mono" 2>/dev/null \
    | grep -Fq "Hack Nerd Font Mono"; then
  font_found=1
elif [ -f "$HOME/Library/Fonts/HackNerdFontMono-Regular.ttf" ]; then
  font_found=1
elif [ -f "${XDG_DATA_HOME:-$HOME/.local/share}/fonts/HackNerdFont/HackNerdFontMono-Regular.ttf" ]; then
  font_found=1
fi

if [ "$font_found" -eq 1 ]; then
  ok "Hack Nerd Font Mono"
else
  warn "Hack Nerd Font Mono missing"
fi

echo ""
echo "== shell and git =="
if command -v zsh >/dev/null 2>&1; then
  if zsh -dfc 'source "$1"' zsh "$ROOT/zsh/zshrc" >/dev/null 2>&1; then
    ok "Zsh configuration"
  else
    warn "Zsh configuration failed to load"
  fi
fi

if command -v git >/dev/null 2>&1; then
  if git config --file "$ROOT/git/gitconfig" --list >/dev/null; then
    ok "Git configuration"
  else
    warn "Git configuration failed to load"
  fi

  if [ -n "$(git config --global --get user.name 2>/dev/null || true)" ] \
    && [ -n "$(git config --global --get user.email 2>/dev/null || true)" ]; then
    ok "Git identity"
  else
    warn "Git identity missing from ~/.gitconfig.local"
  fi
fi

echo ""
echo "== wezterm =="
if [ -n "$WEZTERM_BIN" ]; then
  wezterm_log="$(mktemp "${TMPDIR:-/tmp}/dotfiles-wezterm.XXXXXX")"
  if "$WEZTERM_BIN" --config-file "$ROOT/wezterm/wezterm.lua" show-keys >/dev/null 2>"$wezterm_log"; then
    if grep -Fq "Unable to load a font" "$wezterm_log"; then
      warn "WezTerm config loads but its font cannot be resolved"
    else
      ok "configuration"
    fi
  else
    warn "configuration failed to load"
    sed -n '1,8p' "$wezterm_log" >&2
  fi
  rm -f "$wezterm_log"
fi

echo ""
echo "== neovim =="
if command -v nvim >/dev/null 2>&1; then
  runtime_dir="${TMPDIR:-/tmp}/dotfiles-nvim-runtime"
  mkdir -p "$runtime_dir"
  if nvim --clean --headless \
    "+lua local v = vim.version(); assert(v.major > 0 or v.minor >= 11, 'Neovim 0.11+ required')" \
    "+qa" >/dev/null 2>&1; then
    ok "$(nvim --version | head -n 1)"
  else
    warn "Neovim 0.11 or newer is required"
  fi

  if XDG_RUNTIME_DIR="$runtime_dir" NVIM_LOG_FILE="$runtime_dir/nvim.log" \
    nvim --headless --cmd "set shadafile=NONE" "+lua print('nvim ' .. tostring(vim.g.colors_name or 'no theme'))" "+qa"; then
    printf "\n"
    ok "configuration"
  else
    warn "configuration failed to load"
  fi

  if "$ROOT/scripts/check-mason-tools.sh"; then
    :
  else
    warn "Mason language tools are incomplete"
  fi
fi

echo "== herdr =="
if command -v herdr >/dev/null 2>&1; then
  if HERDR_CONFIG_PATH="$ROOT/herdr/config.toml" herdr config check; then
    ok "configuration"
  else
    warn "configuration failed validation"
  fi

  integration_status="$(herdr integration status 2>&1 || true)"
  for integration in codex kimi grok; do
    if printf '%s\n' "$integration_status" | grep -Eq "^$integration: current"; then
      ok "$integration integration"
    else
      warn "$integration integration is not current"
    fi
  done
fi

echo ""
if [ "$WARNINGS" -eq 0 ]; then
  echo "all checks passed"
else
  echo "$WARNINGS warning(s) found"
  exit 1
fi
