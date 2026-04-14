#!/usr/bin/env bash
set -e

UNINSTALL_FIREFOX=false

for arg in "$@"; do
  case "$arg" in
    --uninstall-firefox)
      UNINSTALL_FIREFOX=true
      ;;
    *)
      echo "Unknown argument: $arg"
      echo "Usage: $0 [--uninstall-firefox]"
      exit 1
      ;;
  esac
done

echo "🚀 Starting Fedora dev environment setup..."

# Add custom Oh My Zsh extensions here using the format:
#   "owner/repo:plugin-directory-name"
# Example:
#   "zsh-users/zsh-autosuggestions:zsh-autosuggestions"
#   "zsh-users/zsh-syntax-highlighting:zsh-syntax-highlighting"
OH_MY_ZSH_EXTENSIONS=(
)

uninstall_firefox() {
  echo "Checking for Firefox installations to remove..."

  if rpm -q firefox &>/dev/null; then
    echo "Removing Firefox RPM package..."
    sudo dnf remove -y firefox
  else
    echo "Firefox RPM package not installed"
  fi

  if command -v flatpak &>/dev/null && flatpak info org.mozilla.firefox &>/dev/null; then
    echo "Removing Firefox Flatpak..."
    flatpak uninstall -y org.mozilla.firefox
  else
    echo "Firefox Flatpak not installed"
  fi
}

# -----------------------------
# 1. System update
# -----------------------------
sudo dnf update -y

# -----------------------------
# 2. Base packages
# -----------------------------
sudo dnf install -y \
  git curl wget unzip \
  zsh tmux \
  neovim \
  fzf fd

# Fedora uses "fd", not fd-find (that's Debian naming)
# fzf sometimes needs keybindings manually enabled later

# -----------------------------
# 3. GitHub CLI (gh)
# -----------------------------
if ! command -v gh &>/dev/null; then
  echo "Installing GitHub CLI..."
  sudo dnf install -y gh
fi

# -----------------------------
# 4. Lazygit
# -----------------------------
if ! command -v lazygit &>/dev/null; then
  echo "Installing lazygit..."
  LAZYGIT_VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep tag_name | cut -d '"' -f 4)
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION#v}_Linux_x86_64.tar.gz"
  tar xf lazygit.tar.gz lazygit
  sudo install lazygit /usr/local/bin
  rm -f lazygit lazygit.tar.gz
fi

# -----------------------------
# 5. NVM (Node Version Manager)
# -----------------------------
if [ ! -d "$HOME/.nvm" ]; then
  echo "Installing nvm..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi

# Load nvm immediately
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install latest LTS Node
nvm install --lts
nvm use --lts

# -----------------------------
# 6. Google Chrome
# -----------------------------
if [ "$UNINSTALL_FIREFOX" = true ]; then
  uninstall_firefox
fi

if ! command -v google-chrome &>/dev/null; then
  echo "Installing Google Chrome..."
  sudo dnf install -y https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
  sudo dnf install -y google-chrome-stable
fi

# -----------------------------
# 7. Ghostty (terminal)
# -----------------------------
if ! command -v ghostty &>/dev/null; then
  echo "Installing Ghostty..."
  sudo dnf copr enable pgdev/ghostty -y
  sudo dnf install -y ghostty
fi

# -----------------------------
# 8. Oh My Zsh
# -----------------------------
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  RUNZSH=no CHSH=no sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# -----------------------------
# 9. Set Zsh as default shell
# -----------------------------
if [ "$SHELL" != "$(which zsh)" ]; then
  chsh -s "$(which zsh)"
fi

# -----------------------------
# 10. Oh My Zsh custom extensions
# -----------------------------
if [ -d "$HOME/.oh-my-zsh" ] && [ ${#OH_MY_ZSH_EXTENSIONS[@]} -gt 0 ]; then
  echo "Installing Oh My Zsh extensions..."

  ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

  for extension in "${OH_MY_ZSH_EXTENSIONS[@]}"; do
    repo="${extension%%:*}"
    plugin_name="${extension##*:}"
    plugin_dir="$ZSH_CUSTOM/plugins/$plugin_name"

    if [ -d "$plugin_dir" ]; then
      echo "Oh My Zsh extension already installed: $plugin_name"
      continue
    fi

    echo "Installing Oh My Zsh extension: $plugin_name"
    git clone "https://github.com/$repo.git" "$plugin_dir"
  done
fi

# -----------------------------
# 11. fzf keybindings + completion
# -----------------------------
if [ -f /usr/share/fzf/shell/key-bindings.zsh ]; then
  echo "Configuring fzf for zsh..."
  echo "[ -f /usr/share/fzf/shell/key-bindings.zsh ] && source /usr/share/fzf/shell/key-bindings.zsh" >>~/.zshrc
  echo "[ -f /usr/share/fzf/shell/completion.zsh ] && source /usr/share/fzf/shell/completion.zsh" >>~/.zshrc
fi

# -----------------------------
# Done
# -----------------------------
echo "✅ Setup complete!"
echo "👉 Restart your terminal or run: exec zsh"

# -----------------------------
# 12. Apply custom .zshrc
# -----------------------------
ZSHRC_SOURCE="$HOME/.config/nvim/zshrc.txt"
ZSHRC_TARGET="$HOME/.zshrc"

if [ -f "$ZSHRC_SOURCE" ]; then
  echo "Applying custom .zshrc from $ZSHRC_SOURCE..."

  # Backup existing .zshrc if it exists
  if [ -f "$ZSHRC_TARGET" ]; then
    cp "$ZSHRC_TARGET" "$ZSHRC_TARGET.backup.$(date +%s)"
    echo "Backed up existing .zshrc"
  fi

  cp "$ZSHRC_SOURCE" "$ZSHRC_TARGET"
  echo "Custom .zshrc applied ✅"
else
  echo "⚠️ No zshrc.txt found at $ZSHRC_SOURCE — skipping"
fi

# -----------------------------
# 13. GNOME Tweaks + Extensions
# -----------------------------
echo "Installing GNOME Tweaks and Extensions..."

sudo dnf install -y \
  gnome-tweaks \
  gnome-extensions-app \
  gnome-shell-extension-appindicator \
  gnome-shell-extension-user-theme

# Enable useful extensions (safe defaults)
gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com || true
gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com || true

# -----------------------------
# 14. Fonts
# -----------------------------
echo "Installing fonts for Poimandres-style GNOME setup..."

sudo dnf install -y \
  google-roboto-fonts \
  vercel-geist-mono-fonts

# Refresh font cache
fc-cache -fv

# Roboto keeps the desktop UI clean and soft while Geist Mono
# remains the coding/terminal font that fits the Poimandres palette well.
if command -v gsettings &>/dev/null; then
  echo "Applying GNOME font settings..."
  gsettings set org.gnome.desktop.interface font-name "Roboto 11" || true
  gsettings set org.gnome.desktop.interface document-font-name "Roboto 11" || true
  gsettings set org.gnome.desktop.interface monospace-font-name "Geist Mono 11" || true
  gsettings set org.gnome.desktop.wm.preferences titlebar-font "Roboto Bold 11" || true
fi

# -----------------------------
# 17. Poimandres Theme Setup
# -----------------------------
echo "Applying Poimandres theme..."

# -----------------------------
# Ghostty
# -----------------------------
GHOSTTY_CONFIG="$HOME/.config/ghostty/config"
mkdir -p "$(dirname "$GHOSTTY_CONFIG")"

cat >"$GHOSTTY_CONFIG" <<'EOF'
background = #1b1e28
foreground = #a6accd

font-family = "Geist Mono"

cursor-color = #add7ff

palette = 0=#1b1e28
palette = 1=#d0679d
palette = 2=#5de4c7
palette = 3=#fffac2
palette = 4=#89ddff
palette = 5=#fcc5e9
palette = 6=#add7ff
palette = 7=#ffffff

palette = 8=#444a73
palette = 9=#d0679d
palette = 10=#5de4c7
palette = 11=#fffac2
palette = 12=#add7ff
palette = 13=#fae4fc
palette = 14=#89ddff
palette = 15=#ffffff
EOF

echo "Ghostty theme applied"

# -----------------------------
# Lazygit
# -----------------------------
LAZYGIT_CONFIG="$HOME/.config/lazygit/config.yml"
mkdir -p "$(dirname "$LAZYGIT_CONFIG")"

cat >"$LAZYGIT_CONFIG" <<'EOF'
gui:
  theme:
    activeBorderColor:
      - "#89ddff"
      - bold
    inactiveBorderColor:
      - "#444a73"
    optionsTextColor:
      - "#89ddff"
    selectedLineBgColor:
      - "#303340"
    cherryPickedCommitFgColor:
      - "#5de4c7"
    cherryPickedCommitBgColor:
      - "#1b1e28"
    unstagedChangesColor:
      - "#d0679d"
    defaultFgColor:
      - "#a6accd"
EOF

echo "Lazygit theme applied"

# -----------------------------
# Tmux
# -----------------------------
TMUX_CONFIG="$HOME/.tmux.conf"

cat >"$TMUX_CONFIG" <<'EOF'
# Enable true color
set -g default-terminal "tmux-256color"
set -ga terminal-overrides ",*:Tc"
set-option -g base-index 1
set-option -g pane-base-index 1

# Status bar
set -g status-style "bg=#1b1e28,fg=#a6accd"

set -g status-left "#[fg=#5de4c7]tmux "
set -g status-right "#[fg=#89ddff]%Y-%m-%d %H:%M"

# Window tabs
set -g window-status-format "#[fg=#444a73] #I:#W "
set -g window-status-current-format "#[fg=#1b1e28,bg=#89ddff,bold] #I:#W "

# Pane borders
set -g pane-border-style "fg=#444a73"
set -g pane-active-border-style "fg=#89ddff"

# Message styling
set -g message-style "bg=#1b1e28,fg=#fffac2"
EOF

echo "Tmux theme applied"

# -----------------------------
# Truecolor support
# -----------------------------
if ! grep -q "COLORTERM=truecolor" "$HOME/.zshrc"; then
  echo 'export COLORTERM=truecolor' >>"$HOME/.zshrc"
fi

echo "Poimandres theme setup complete ✅"


# -----------------------------
# 18. AI Coding CLI tools
# -----------------------------
echo "Installing AI coding tools..."

# Ensure Node is available (nvm already installed earlier)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# Use latest LTS
nvm install --lts >/dev/null
nvm use --lts >/dev/null

# -----------------------------
# Node CLI tooling
# -----------------------------
echo "Installing Node CLI tools..."
npm install -g prettier tree-sitter-cli

# -----------------------------
# OpenAI Codex CLI
# -----------------------------
if ! command -v codex &> /dev/null; then
  echo "Installing Codex CLI..."
  npm install -g @openai/codex
fi
# Codex CLI installs via npm globally :contentReference[oaicite:3]{index=3}

# -----------------------------
# Claude Code
# -----------------------------
if ! command -v claude &> /dev/null; then
  echo "Installing Claude Code..."
  npm install -g @anthropic-ai/claude-code || true
fi

# Note: Claude Code requires API key setup later

# -----------------------------
# OpenCode
# -----------------------------
if ! command -v opencode &> /dev/null; then
  echo "Installing OpenCode..."
  curl -fsSL https://opencode.ai/install | bash
fi

if ! grep -q 'export PATH="$HOME/.opencode/bin:$PATH"' "$HOME/.zshrc"; then
  echo 'export PATH="$HOME/.opencode/bin:$PATH"' >>"$HOME/.zshrc"
fi
# OpenCode provides an install script via curl :contentReference[oaicite:4]{index=4}

echo "AI tools installed ✅"
