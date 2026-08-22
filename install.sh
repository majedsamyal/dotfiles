#!/usr/bin/env bash
# Bootstrap and configure the complete workstation on macOS or Linux.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS="$(uname -s)"

FORCE=0
FULL_SETUP=1
NON_INTERACTIVE=0
CHANGE_SHELL=1
GIT_NAME="${DOTFILES_GIT_NAME:-}"
GIT_EMAIL="${DOTFILES_GIT_EMAIL:-}"
LOGIN_SHELL="${SHELL:-}"

usage() {
  cat <<'EOF'
Usage: ./install.sh [options]

No options are needed for a normal setup. The installer detects macOS or
Linux, installs dependencies, links configs, and initializes every tool.

Options:
  --git-name NAME       Git commit name (prompted when omitted).
  --git-email EMAIL     Git commit email (prompted when omitted).
  --force               Back up and replace existing config files.
  --non-interactive     Never prompt; requires Git name/email and --force
                        when existing config files conflict.
  --no-shell-change     Do not change the login shell to Zsh.
  --links-only          Only create configuration links; install nothing.
  --packages, --brew    Compatibility options; full setup is already default.
  --help                Show this help.
EOF
}

require_value() {
  if [ "$#" -lt 2 ] || [ -z "$2" ]; then
    echo "error $1 requires a value" >&2
    exit 1
  fi
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --git-name)
      require_value "$@"
      GIT_NAME="$2"
      shift 2
      ;;
    --git-email)
      require_value "$@"
      GIT_EMAIL="$2"
      shift 2
      ;;
    --force)
      FORCE=1
      shift
      ;;
    --non-interactive)
      NON_INTERACTIVE=1
      shift
      ;;
    --no-shell-change)
      CHANGE_SHELL=0
      shift
      ;;
    --links-only)
      FULL_SETUP=0
      shift
      ;;
    --packages | --brew)
      FULL_SETUP=1
      shift
      ;;
    --help | -h)
      usage
      exit 0
      ;;
    *)
      echo "error unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

case "$OS" in
  Darwin | Linux) ;;
  *)
    echo "error unsupported operating system: $OS (expected macOS or Linux)" >&2
    exit 1
    ;;
esac

run_as_root() {
  if [ "$(id -u)" -eq 0 ]; then
    "$@"
  elif ! command -v sudo >/dev/null 2>&1; then
    echo "error sudo is required to install host packages" >&2
    return 1
  elif [ "$NON_INTERACTIVE" -eq 1 ]; then
    sudo -n "$@"
  else
    sudo "$@"
  fi
}

load_brew() {
  local brew_bin=""
  if command -v brew >/dev/null 2>&1; then
    brew_bin="$(command -v brew)"
  else
    local candidate
    for candidate in \
      /opt/homebrew/bin/brew \
      /usr/local/bin/brew \
      /home/linuxbrew/.linuxbrew/bin/brew; do
      if [ -x "$candidate" ]; then
        brew_bin="$candidate"
        break
      fi
    done
  fi

  if [ -z "$brew_bin" ]; then
    return 1
  fi

  eval "$("$brew_bin" shellenv)"
}

install_linux_prerequisites() {
  local missing=0
  local command_name
  for command_name in cc curl file git ps; do
    if ! command -v "$command_name" >/dev/null 2>&1; then
      missing=1
    fi
  done

  if [ "$missing" -eq 0 ]; then
    echo "ok    Linux host prerequisites"
    return
  fi

  echo "host: installing Linux prerequisites"
  if command -v apt-get >/dev/null 2>&1; then
    run_as_root apt-get update
    run_as_root apt-get install -y build-essential procps curl file git
  elif command -v dnf >/dev/null 2>&1; then
    run_as_root dnf group install -y development-tools
    run_as_root dnf install -y procps-ng curl file git
  elif command -v pacman >/dev/null 2>&1; then
    run_as_root pacman -S --needed --noconfirm base-devel procps-ng curl file git
  else
    echo "error install a C compiler, procps, curl, file, and git, then rerun" >&2
    echo "      supported automatic package managers: apt, dnf, pacman" >&2
    return 1
  fi
}

install_homebrew() {
  if load_brew; then
    echo "ok    Homebrew"
    return
  fi

  if [ "$OS" = "Linux" ]; then
    install_linux_prerequisites
  elif ! command -v curl >/dev/null 2>&1; then
    echo "error curl is required to bootstrap Homebrew" >&2
    return 1
  fi

  echo "host: installing Homebrew"
  local installer
  installer="$(mktemp "${TMPDIR:-/tmp}/homebrew-install.XXXXXX")"
  curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh -o "$installer"

  if [ "$NON_INTERACTIVE" -eq 1 ]; then
    NONINTERACTIVE=1 /bin/bash "$installer"
  else
    /bin/bash "$installer"
  fi
  rm -f "$installer"

  if ! load_brew; then
    echo "error Homebrew installed but could not be loaded" >&2
    return 1
  fi
}

install_packages() {
  install_homebrew
  echo "packages: installing workstation tools"

  # Keep a direct Herdr installation instead of adding a duplicate managed by
  # Homebrew. Fresh machines receive the Homebrew formula from the Brewfile.
  local brew_skip="${HOMEBREW_BUNDLE_BREW_SKIP:-}"
  if command -v herdr >/dev/null 2>&1; then
    brew_skip="${brew_skip:+$brew_skip }herdr"
  fi

  HOMEBREW_BUNDLE_BREW_SKIP="$brew_skip" \
    brew bundle --file="$ROOT/Brewfile"

  if [ "$OS" = "Linux" ]; then
    "$ROOT/scripts/install-nerd-font.sh"
  fi
}

is_repo_link() {
  [ -L "$2" ] && [ "$(readlink "$2")" = "$1" ]
}

CONFLICT_COUNT=0
CONFLICT_PATHS=""

record_conflict() {
  local src="$1"
  local dest="$2"
  if { [ -e "$dest" ] || [ -L "$dest" ]; } && ! is_repo_link "$src" "$dest"; then
    CONFLICT_COUNT=$((CONFLICT_COUNT + 1))
    CONFLICT_PATHS="$CONFLICT_PATHS\n  $dest"
  fi
}

confirm_conflicts() {
  record_conflict "$ROOT/nvim" "$HOME/.config/nvim"
  record_conflict "$ROOT/wezterm/wezterm.lua" "$HOME/.wezterm.lua"
  record_conflict "$ROOT/herdr/config.toml" "$HOME/.config/herdr/config.toml"
  record_conflict "$ROOT/git/gitconfig" "$HOME/.gitconfig"
  record_conflict "$ROOT/git/gitignore_global" "$HOME/.gitignore_global"
  record_conflict "$ROOT/zsh/zshrc" "$HOME/.zshrc"

  if [ "$CONFLICT_COUNT" -eq 0 ] || [ "$FORCE" -eq 1 ]; then
    return
  fi

  printf 'Existing configuration files need to be backed up:%b\n' "$CONFLICT_PATHS"
  if [ "$NON_INTERACTIVE" -eq 1 ] || [ ! -t 0 ]; then
    echo "error rerun with --force to back up and replace them" >&2
    return 1
  fi

  local reply
  read -r -p "Back up and replace these files? [y/N] " reply
  case "$reply" in
    y | Y | yes | YES) FORCE=1 ;;
    *)
      echo "cancelled"
      exit 1
      ;;
  esac
}

link() {
  local src="$1"
  local dest="$2"

  mkdir -p "$(dirname "$dest")"
  if is_repo_link "$src" "$dest"; then
    echo "ok    $dest"
    return
  fi

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    local backup="$dest.bak"
    local suffix=1
    while [ -e "$backup" ] || [ -L "$backup" ]; do
      backup="$dest.bak.$suffix"
      suffix=$((suffix + 1))
    done
    mv "$dest" "$backup"
    echo "bak   $dest -> $backup"
  fi

  ln -s "$src" "$dest"
  echo "link  $dest -> $src"
}

link_configs() {
  echo "dotfiles: linking configuration ($OS)"
  link "$ROOT/nvim" "$HOME/.config/nvim"
  link "$ROOT/wezterm/wezterm.lua" "$HOME/.wezterm.lua"
  link "$ROOT/herdr/config.toml" "$HOME/.config/herdr/config.toml"
  link "$ROOT/git/gitconfig" "$HOME/.gitconfig"
  link "$ROOT/git/gitignore_global" "$HOME/.gitignore_global"
  link "$ROOT/zsh/zshrc" "$HOME/.zshrc"
}

prompt_required() {
  local label="$1"
  local value=""
  while [ -z "$value" ]; do
    if ! read -r -p "$label: " value; then
      echo "error input ended before $label was provided" >&2
      return 1
    fi
  done
  printf '%s' "$value"
}

configure_git_identity() {
  local config_file="$HOME/.gitconfig.local"

  if [ -z "$GIT_NAME" ]; then
    GIT_NAME="$(git config --file "$config_file" --get user.name 2>/dev/null || true)"
  fi
  if [ -z "$GIT_EMAIL" ]; then
    GIT_EMAIL="$(git config --file "$config_file" --get user.email 2>/dev/null || true)"
  fi

  if [ "$NON_INTERACTIVE" -eq 1 ] && { [ -z "$GIT_NAME" ] || [ -z "$GIT_EMAIL" ]; }; then
    echo "error --non-interactive requires --git-name and --git-email on a new machine" >&2
    return 1
  fi

  if [ -z "$GIT_NAME" ]; then
    GIT_NAME="$(prompt_required "Git name")"
  fi
  if [ -z "$GIT_EMAIL" ]; then
    GIT_EMAIL="$(prompt_required "Git email")"
  fi

  git config --file "$config_file" user.name "$GIT_NAME"
  git config --file "$config_file" user.email "$GIT_EMAIL"
  echo "git:  identity stored in $config_file"
}

configure_login_shell() {
  if [ "$CHANGE_SHELL" -eq 0 ]; then
    echo "skip  login shell change"
    return
  fi

  local target_shell
  if [ "$OS" = "Darwin" ]; then
    target_shell=/bin/zsh
  else
    target_shell="$(brew --prefix)/bin/zsh"
  fi

  if [ ! -x "$target_shell" ]; then
    echo "error Zsh was not found at $target_shell" >&2
    return 1
  fi

  LOGIN_SHELL="$target_shell"
  if [ "${SHELL:-}" = "$target_shell" ]; then
    echo "ok    login shell $target_shell"
    return
  fi

  if ! grep -qxF "$target_shell" /etc/shells; then
    printf '%s\n' "$target_shell" | run_as_root tee -a /etc/shells >/dev/null
  fi

  local user_name
  user_name="$(id -un)"
  if command -v chsh >/dev/null 2>&1; then
    run_as_root chsh -s "$target_shell" "$user_name"
  elif command -v usermod >/dev/null 2>&1; then
    run_as_root usermod --shell "$target_shell" "$user_name"
  else
    echo "error neither chsh nor usermod is available to change the login shell" >&2
    return 1
  fi
  echo "shell: login shell changed to $target_shell"
}

configure_herdr() {
  local herdr_bin
  herdr_bin="$(command -v herdr || true)"
  if [ -z "$herdr_bin" ]; then
    echo "error Herdr was not installed" >&2
    return 1
  fi

  for integration in codex kimi grok; do
    "$herdr_bin" integration install "$integration"
  done
}

bootstrap_neovim() {
  echo "neovim: installing plugins"
  nvim --headless "+Lazy! install" +qa
  echo "neovim: installing language servers and formatters"
  nvim --headless "+MasonToolsInstallSync" +qa
  "$ROOT/scripts/check-mason-tools.sh"
}

confirm_conflicts

if [ "$FULL_SETUP" -eq 1 ]; then
  install_packages
fi

link_configs

if [ "$FULL_SETUP" -eq 0 ]; then
  echo "done  configuration links installed"
  exit 0
fi

configure_git_identity
configure_login_shell
configure_herdr
bootstrap_neovim

echo "verify: checking complete workstation"
if [ "$CHANGE_SHELL" -eq 1 ]; then
  SHELL="$LOGIN_SHELL" "$ROOT/check.sh"
else
  DOTFILES_ALLOW_NON_ZSH=1 "$ROOT/check.sh"
fi

echo "done  workstation is ready; restart the terminal to load the login shell"
