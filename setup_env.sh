#! /bin/bash

set -eux

# add epel repository
wget http://ftp-srv2.kddilabs.jp/Linux/distributions/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm
rpm -ivh epel-release-6-8.noarch.rpm

# install tmux
yum install tmux
cp tmux.conf ~/.tmux.conf

# install emacs26
pushd /tmp
wget http://ftp.gnu.org/pub/gnu/emacs/emacs-26.1.tar.gz
tar zxvf emacs-26.1.tar.gz
cd emacs-26.1
./configure --without-x
make
make install
popd
cp -rf emacs.d ~/.emacs.d

# install cask
curl -fsSL https://raw.githubusercontent.com/cask/cask/master/go | python

# load .zshrc
cp zshrc ~/.zshrc
source ~/.zshrc

# setup emacs addons
pushd ~/.emacs.d
cask install
popd

# install miniconda3
pushd /tmp
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
./Miniconda3-latest-Linux-x86_64.sh -b
popd

# load .zshrc
cp zshrc ~/.zshrc
source ~/.zshrc
