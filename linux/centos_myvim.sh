#!/usr/bin/env bash

# -----------------------------------------------
# Author : Jiaobuzuji@163.com
# Reference : https://github.com/Valloric/YouCompleteMe/wiki/Building-Vim-from-source
# -----------------------------------------------

# sudo yum install -y ruby ruby-devel lua lua-devel luajit \
#     luajit-devel ctags git python python-devel \
#     python3 python3-devel tcl-devel \
#     perl perl-devel perl-ExtUtils-ParseXS \
#     perl-ExtUtils-XSpp perl-ExtUtils-CBuilder \
#     perl-ExtUtils-Embed

sudo make uninstall
sudo make clean
sudo make distclean

# --enable-luainterp=dynamic
# --enable-rubyinterp=dynamic
# --enable-pythoninterp=dynamic
# --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu
# --with-x
# --with-python3-config-dir=/usr/lib64/python3.4/config-3.4m
# CFLAGS="-g -DDEBUG -Wall -Wshadow -Wmissing-prototypes"

./configure \
  --enable-fail-if-missing \
  --disable-darwin \
  --enable-gui=auto \
  --enable-xim \
  --enable-fontset \
  --enable-gpm \
  --with-features=huge \
  --enable-perlinterp=dynamic \
  --enable-python3interp=dynamic \
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
sudo make install
# make uninstall

sudo update-alternatives --install /usr/bin/editor editor /usr/bin/vim 1
sudo update-alternatives --set editor /usr/bin/vim
sudo update-alternatives --install /usr/bin/vi vi /usr/bin/vim 1
sudo update-alternatives --set vi /usr/bin/vim
