Conf

steps
1. Install ZSH
```bash
sudo apt update
sudo apt install zsh -y
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

2. Install tmux
```bash
sudo apt update
sudo apt install tmux -y
```

3. Install neovim
```bash
wget https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
./nvim.appimage
```

```bash
sudo mv nvim.appimage /usr/local/bin/nvim
```

4. Clone this repo
```bash
rm -rf ~/.config/nvim   # Remove old config (optional but safe if you're starting fresh)
git clone https://github.com/JanGabrielqqq/nvimconfig.git ~/.config/nvim

```

5. Install NVM
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
source ~/.zshrc
```

1. Run following commands
```bash
cp ~/.config/nvim/zshrc.txt ~/.zshrc
cp ~/.config/nvim/tmux.conf.txt ~/tmux.conf
cp ~/.config/nvim/tsesh.sh.text ~/tsesh.sh
source ~/.zshrc
tmux source-file ~/tmux.conf
chmod u+x ~/tsesh.sh
```

2. Install fd ripgrep lazygit fzf gh
```bash
sudo apt update
sudo apt install fd-find
sudo ln -s $(which fdfind) /usr/local/bin/fd
sudo apt install ripgrep
sudo apt install fzf

wget https://github.com/jesseduffield/lazygit/releases/download/v0.49.0/lazygit_0.49.0_Linux_x86_64.tar.gz
tar -xvzf lazygit_0.49.0_Linux_x86_64.tar.gz
sudo mv lazygit /usr/local/bin/
rm lazygit_0.49.0_Linux_x86_64.tar.gz
```


```bash
type -p curl >/dev/null || sudo apt install curl -y
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
  sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | \
  sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

sudo apt update
sudo apt install gh -y

```
