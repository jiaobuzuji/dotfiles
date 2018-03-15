#!/usr/bin/env bash

# -----------------------------------------------
# Author : Jiaobuzuji@163.com
# Reference : https://github.com/Valloric/YouCompleteMe/wiki/Building-Vim-from-source
# -----------------------------------------------

# TODO : You may install python34.i686 instead of python3, python34-devel.i686
# instead of python3-devel
# sudo yum install -y ruby ruby-devel lua lua-devel luajit \
#     luajit-devel ctags git python python-devel \
#     python3 python3-devel tcl-devel \
#     perl perl-devel perl-ExtUtils-ParseXS \
#     perl-ExtUtils-XSpp perl-ExtUtils-CBuilder \
#     perl-ExtUtils-Embed
# yum install ncurses-devel mercurial python python-devel perl-devel ruby ruby-devel lua lua-devel
# yum install libgnome-devel libgnomeui-devel gtk2-devel atk-devel libbonoboui-devel cairo-devel libX11-devel libXpm-devel libXt-devel
# yum install epel-release
# yum install python34 python34-deve

sudo make uninstall
sudo make clean
sudo make distclean

# --enable-luainterp=dynamic
# --enable-rubyinterp=dynamic
  # --enable-python3interp=dynamic \
  # --with-python3-config-dir=/usr/lib/python3.4/config-3.4m \
  # --with-python-config-dir=/usr/lib/python2.6/config
# --with-x
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
  --enable-pythoninterp=dynamic \
  --enable-tclinterp=dynamic \
  --enable-cscope \
  --enable-terminal \
  --enable-autoservername \
  --enable-multibyte \
  --prefix=/usr \
  --with-compiledby=jiaobuzuji@163.com

if [ $? -eq 0 ]; then
  make VIMRUNTIMEDIR=/usr/share/vim/vim80
  # make test

  # official install flow
  sudo make install
  # make uninstall

  sudo update-alternatives --install /usr/bin/editor editor /usr/bin/vim 1
  sudo update-alternatives --set editor /usr/bin/vim
  sudo update-alternatives --install /usr/bin/vi vi /usr/bin/vim 1
  sudo update-alternatives --set vi /usr/bin/vim
fi
