# Shared workstation packages for macOS and Linux.
# Install through ./install.sh so platform setup also runs.

# terminal
cask "wezterm" if OS.mac?
cask "font-hack-nerd-font" if OS.mac?
tap "wezterm/wezterm-linuxbrew" if OS.linux?
brew "wezterm/wezterm-linuxbrew/wezterm" if OS.linux?

# editor
brew "neovim"
brew "node"     # needed by Mason for pyright, ts_ls, etc.
brew "stylua"

# language runtimes used by configured servers and formatters
brew "go"
brew "python"
brew "rust"
tap "hashicorp/tap"
brew "hashicorp/tap/terraform"

# shell
brew "zsh-autosuggestions"
brew "zsh-syntax-highlighting"
brew "zsh" if OS.linux?
brew "fzf"
brew "zoxide"
brew "eza"
brew "bat"
brew "starship"

# git
brew "git"
brew "lazygit"
brew "herdr"

# search
brew "ripgrep"

# Neovim clipboard providers. Both are installed so the same machine can use
# either a Wayland or X11 session without changing this setup.
brew "wl-clipboard" if OS.linux?
brew "xclip" if OS.linux?
brew "fontconfig" if OS.linux?
brew "unzip" if OS.linux?
