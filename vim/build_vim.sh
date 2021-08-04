#!/usr/bin/env bash

# -----------------------------------------------------------------
# Author : Jiaobuzuji@163.com
# Reference : https://github.com/Valloric/YouCompleteMe/wiki/Building-Vim-from-source
# -----------------------------------------------------------------

# Centos
# sudo yum install -y \
#     ruby ruby-devel lua lua-devel luajit luajit-devel \
#     python python-devel python3 python3-devel python36 python36-devel \
#     perl perl-devel perl-ExtUtils-ParseXS \
#     perl-ExtUtils-XSpp perl-ExtUtils-CBuilder \
#     perl-ExtUtils-Embed perl-YAML \
#     tcl tcl-devel \
#     libgnome-devel libgnomeui-devel gtk2-devel atk-devel libbonoboui-devel cairo-devel \
#     libX11-devel ncurses-devel libXpm-devel libXt-devel libcxx \
#     libsodium libsodium-devel \
#     ctags cscope git
# sudo yum remove -y vim gvim vim-runtime vim-common vim-enhanced

# Ubuntu TODO
# sudo apt install -y \
#     libncurses5-dev libgnome2-dev libgnomeui-dev \
#     libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
#     libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
#     python3-dev ruby-dev lua5.1 lua5.1-dev libperl-dev git
# sudo apt remove -y vim gvim vim-runtime

# -----------------------------------------------------------------
# Before 'configure', you must distclean source.
sudo make uninstall
sudo make clean distclean

  # --with-python3-config-dir=/usr/lib/python3.4/config-3.4m
  # --with-python-config-dir=/usr/lib/python2.6/config
  # --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu
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
  --enable-luainterp=dynamic \
  --enable-mzschemeinterp \
  --enable-perlinterp=dynamic \
  --enable-pythoninterp=dynamic \
  --enable-python3interp=dynamic \
  --enable-rubyinterp=dynamic \
  --enable-tclinterp=dynamic \
  --enable-cscope \
  --enable-terminal \
  --enable-autoservername \
  --enable-multibyte \
  --prefix=/usr \
  --with-compiledby=jiaobuzuji@163.com
# Go to 'src/auto/config.log' and check

if [ $? -eq 0 ]; then
  make -j$(nproc)
  # make VIMRUNTIMEDIR=/usr/share/vim/vim82
  # make test

  # official install flow
  sudo make install
  # make uninstall

  # package for Debain linux
  # sudo checkinstall
  # sudo dpkg -r vim.git # uninstall

  sudo update-alternatives --install /usr/bin/editor editor /usr/bin/vim 1
  sudo update-alternatives --set editor /usr/bin/vim
  sudo update-alternatives --install /usr/bin/vi vi /usr/bin/vim 1
  sudo update-alternatives --set vi /usr/bin/vim
fi

