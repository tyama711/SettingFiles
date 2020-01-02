#!/usr/bin/env zsh

mkdir -p ~/archives
pushd ~/archives

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


# Setup Doom Emacs
cd ~

git clone https://github.com/tyama711/doom-emacs ~/.emacs.d
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
cp -rb ~/dotfiles/.sshrc.d ./
sudo install -m 755 dotfiles/sshrc /usr/bin

popd
