#!/bin/bash

# -----------------------------------------------
# Author : Jiaobuzuji@163.com
# Reference : https://github.com/Valloric/YouCompleteMe/wiki/Building-Vim-from-source
# -----------------------------------------------

# sudo apt install libncurses5-dev libgnome2-dev libgnomeui-dev \
#     libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
#     libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
#     python3-dev ruby-dev lua5.1 lua5.1-dev libperl-dev git

sudo make uninstall
sudo make clean
sudo make distclean
sudo apt remove vim vim-runtime gvim

# --enable-luainterp=dynamic
# --enable-rubyinterp=dynamic
# --enable-pythoninterp=dynamic
# --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu
# --with-x
# CFLAGS="-g -DDEBUG -Wall -Wshadow -Wmissing-prototypes"

./configure \
  --enable-fail-if-missing \
  --disable-darwin \
  --enable-gui=auto \
  --enable-xim \
  --enable-fontset \
  --with-features=huge \
  --enable-perlinterp=dynamic \
  --enable-python3interp=dynamic \
  --with-python3-config-dir=/usr/lib/python3.5/config-3.5m-x86_64-linux-gnu \
  --enable-tclinterp=dynamic \
  --enable-cscope \
  --enable-terminal \
  --enable-autoservername \
  --enable-multibyte \
  --prefix=/usr \
  --with-compiledby=jiaobuzuji@163.com
make VIMRUNTIMEDIR=/usr/share/vim/vim80
# make test

# official install flow
# sudo make install
# make uninstall

# package for Debain linux
sudo checkinstall
# sudo dpkg -r vim.git # uninstall

sudo update-alternatives --install /usr/bin/editor editor /usr/bin/vim 1
sudo update-alternatives --set editor /usr/bin/vim
sudo update-alternatives --install /usr/bin/vi vi /usr/bin/vim 1
sudo update-alternatives --set vi /usr/bin/vim
