#!/usr/bin/env bash
# Verify every executable managed by the Neovim Mason configuration.
set -euo pipefail

if ! command -v nvim >/dev/null 2>&1; then
  echo "error Neovim is required to locate Mason tools" >&2
  exit 1
fi

mason_bin="$(
  nvim --clean --headless --cmd 'set shadafile=NONE' \
    '+lua io.write(vim.fn.stdpath("data") .. "/mason/bin")' +qa
)"

missing=""
for executable in \
  bash-language-server \
  docker-langserver \
  gofumpt \
  gopls \
  lua-language-server \
  prettier \
  pyright-langserver \
  ruff \
  rust-analyzer \
  stylua \
  terraform-ls \
  typescript-language-server \
  vscode-json-language-server \
  yaml-language-server; do
  if [ ! -x "$mason_bin/$executable" ]; then
    missing="${missing:+$missing, }$executable"
  fi
done

if [ -n "$missing" ]; then
  echo "error missing Mason tools: $missing" >&2
  exit 1
fi

echo "ok    Mason language tools"
