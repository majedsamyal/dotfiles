#!/usr/bin/env bash
# Install the font used by WezTerm into the per-user Linux font directory.
set -euo pipefail

if [ "$(uname -s)" != "Linux" ]; then
  echo "skip  Hack Nerd Font installer is only needed on Linux"
  exit 0
fi

font_dir="${XDG_DATA_HOME:-$HOME/.local/share}/fonts/HackNerdFont"

if command -v fc-match >/dev/null 2>&1 \
  && fc-match -f '%{family}\n' "Hack Nerd Font Mono" 2>/dev/null \
    | grep -Fq "Hack Nerd Font Mono"; then
  echo "ok    Hack Nerd Font Mono"
  exit 0
fi

for command_name in curl unzip; do
  if ! command -v "$command_name" >/dev/null 2>&1; then
    echo "error $command_name is required to install Hack Nerd Font Mono" >&2
    exit 1
  fi
done

mkdir -p "$font_dir"
archive="$(mktemp "${TMPDIR:-/tmp}/hack-nerd-font.XXXXXX")"
trap 'rm -f "$archive"' EXIT

echo "font: downloading Hack Nerd Font Mono"
curl -fsSL \
  https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip \
  -o "$archive"
unzip -q -o "$archive" '*.ttf' -d "$font_dir"

if command -v fc-cache >/dev/null 2>&1; then
  fc-cache -f "$font_dir" >/dev/null
fi

echo "font: installed in $font_dir"
