#!/usr/bin/env bash
set -e

echo "🚀 Starting Fedora dev environment setup..."

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
if ! command -v google-chrome &>/dev/null; then
  echo "Installing Google Chrome..."
  sudo dnf install -y fedora-workstation-repositories
  sudo dnf config-manager --set-enabled google-chrome
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
# 10. fzf keybindings + completion
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
# 11. Apply custom .zshrc
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
