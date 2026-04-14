# Neovim Config

Personal Neovim setup built on top of `LazyVim`.

This repo also includes companion shell and tmux files:

- `zshrc.txt`
- `tmux.conf.txt`
- `tsesh.sh.txt`
- `tnsesh.sh.txt`

The instructions below are written for a fresh Linux machine.

## What this config uses

- `neovim`
- `git`
- `zsh` + `oh-my-zsh`
- `tmux`
- `fzf`
- `fd`
- `ripgrep`
- `lazygit`
- `Node.js` via `nvm`

Neovim will bootstrap `lazy.nvim` automatically on first launch.

## Fresh Start Setup

### 1. Install base packages

#### Ubuntu / Debian

```bash
sudo apt update
sudo apt install -y git curl wget unzip zsh tmux fzf ripgrep fd-find
```

Create the `fd` alias command expected by many plugins:

```bash
sudo ln -sf "$(which fdfind)" /usr/local/bin/fd
```

#### Fedora

```bash
sudo dnf update -y
sudo dnf install -y git curl wget unzip zsh tmux neovim fzf fd ripgrep
```

### 2. Install Neovim

If your package manager already installed a recent `nvim`, you can skip this step.

For Ubuntu / Debian, the AppImage route is usually the easiest way to get a newer release:

```bash
cd /tmp
wget https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
chmod u+x nvim-linux-x86_64.appimage
sudo mv nvim-linux-x86_64.appimage /usr/local/bin/nvim
```

Verify:

```bash
nvim --version
```

### 3. Install Oh My Zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
chsh -s "$(which zsh)"
```

Log out and back in, or run:

```bash
exec zsh
```

### 4. Install `nvm` and Node.js

Some Neovim tooling in this config expects Node to exist.

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
nvm install --lts
nvm use --lts
```

### 5. Install `lazygit`

```bash
LAZYGIT_VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep tag_name | cut -d '"' -f 4)
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION#v}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
rm -f lazygit lazygit.tar.gz
```

Verify:

```bash
lazygit --version
```

### 6. Clone this repo

If you already have another Neovim config, back it up first.

```bash
mv ~/.config/nvim ~/.config/nvim.backup 2>/dev/null || true
git clone https://github.com/JanGabrielqqq/nvimconfig.git ~/.config/nvim
```

### 7. Copy the companion shell and tmux files

```bash
cp ~/.config/nvim/zshrc.txt ~/.zshrc
cp ~/.config/nvim/tmux.conf.txt ~/.tmux.conf
cp ~/.config/nvim/tsesh.sh.txt ~/tsesh.sh
cp ~/.config/nvim/tnsesh.sh.txt ~/tnsesh.sh
chmod u+x ~/tsesh.sh ~/tnsesh.sh
```

Reload them:

```bash
source ~/.zshrc
tmux source-file ~/.tmux.conf 2>/dev/null || true
```

### 8. Install tmux plugin manager (TPM)

`tmux.conf.txt` expects TPM.

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Inside tmux, press `prefix + I` to install tmux plugins.

### 9. Start Neovim for the first time

```bash
nvim
```

On first launch, Neovim should:

- install `lazy.nvim`
- install plugins from `LazyVim`
- load the `poimandres` colorscheme

After Neovim opens, run:

```vim
:Lazy sync
:Mason
:checkhealth
```

Use `:Mason` to install any language servers or formatters you want.

## Optional

### Fedora one-shot setup script

This repo includes `setup.sh` for a more automated Fedora setup:

```bash
cd ~/.config/nvim
chmod u+x setup.sh
./setup.sh
```

Optional flag:

```bash
./setup.sh --uninstall-firefox
```

Review the script before running it. It installs more than Neovim tooling.

## Useful files

- `init.lua`: Neovim entrypoint
- `lua/config`: core config
- `lua/plugins`: plugin overrides
- `setup.sh`: Fedora workstation bootstrap

## Troubleshooting

If Neovim fails on first launch:

```bash
rm -rf ~/.local/share/nvim
rm -rf ~/.cache/nvim
nvim
```

If `fd` is missing but `fdfind` exists:

```bash
sudo ln -sf "$(which fdfind)" /usr/local/bin/fd
```

If Node-based tools do not work:

```bash
node --version
npm --version
```
