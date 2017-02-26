#!/bin/bash

# -----------------------------------------------
# Author : Jiaobuzuji@163.com
# Reference : https://github.com/Valloric/YouCompleteMe/wiki/Building-Vim-from-source
# -----------------------------------------------

# sudo make uninstall
make clean
make distclean

#  --enable-luainterp=dynamic
#  --enable-python3interp=dynamic
#  --with-python3-config-dir=/usr/lib/python3.5/config
#  --enable-rubyinterp=dynamic 
#  --with-x
./configure \
  --prefix=/usr \
  --enable-fail-if-missing \
  --disable-darwin \
  --enable-gui=gtk3 \
  --enable-xim \
  --enable-fontset \
  --with-features=huge \
  --enable-perlinterp=dynamic \
  --enable-pythoninterp=dynamic \
  --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu \
  --enable-tclinterp=dynamic \
  --enable-cscope \
  --enable-multibyte \
  --with-compiledby=jiaobuzuji@163.com && \
make
# make test
sudo make install
# sudo checkinstall
# make uninstall

sudo update-alternatives --install /usr/bin/editor editor /usr/bin/vim 1
sudo update-alternatives --set editor /usr/bin/vim
sudo update-alternatives --install /usr/bin/vi vi /usr/bin/vim 1
sudo update-alternatives --set vi /usr/bin/vim
