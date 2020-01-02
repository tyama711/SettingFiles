#! /usr/bin/env bash

# Clone tyama711/dotfiles repository.
pushd ~
git clone https://github.com/tyama711/dotfiles


mkdir -p ~/archives
cd ~/archives


# Build and install Zsh 5.7.1
sudo apt install yodl

wget https://github.com/zsh-users/zsh/archive/zsh-5.7.1.tar.gz
tar xvzf zsh-5.7.1.tar.gz

pushd zsh-zsh-5.7.1/

./Util/preconfig
./configure
make
make check
sudo make install

popd
rm -rf zsh-zsh-5.7.1

ln -s -f dotfiles/.zshrc ~


# Install Zplugin
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zplugin/master/doc/install.sh)"
zsh -c "zplugin self-update"

cp -b dotfiles/.p10.zsh ~/


# Build and install Emacs 26.3
sudo apt install texinfo libxaw7-dev libgnutls28-dev libjpeg-dev libgif-dev libtiff-dev

wget https://github.com/emacs-mirror/emacs/archive/emacs-26.3.tar.gz
tar xvzf emacs-26.3.tar.gz

pushd emacs-emacs-26.3/

./autogen.sh
./configure
make
make check
sudo make install

popd
rm -rf emacs-emacs-26.3

cp -rb ~/dotfiles/.doom.d ~/


# Setup Doom Emacs
cd ~

git clone https://github.com/hlissner/doom-emacs ~/.emacs.d
yes | ~/.emacs.d/bin/doom install


# Build and install Tmux 3.0a
sudo apt install libevent-dev libncurses5-dev

wget https://github.com/tmux/tmux/releases/download/3.0a/tmux-3.0a.tar.gz
tar xvzf tmux-3.0a.tar.gz

pushd tmux-3.0a

./configure
make
sudo make install


# Install Tmux Config
ghq get https://github.com/tyama711/tmux-config.git
ghq look tmux-config
./tmux-config/install.sh

popd
rm -rf tmux-3.0a


# Install sshrc
cp -rb dotfiles/.sshrc.d ./
sudo install -m 755 dotfiles/sshrc /usr/bin


popd
