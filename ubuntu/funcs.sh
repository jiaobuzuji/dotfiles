#! /usr/bin/env bash

# -----------------------------------------------
# Author : Jiaobuzuji@163.com
# Reference : https://github.com/tracyone/dotfiles/
# Abstract : ubuntu bootstrap functions
# -----------------------------------------------

# function pkg_mirror()
# {
# }

function pkg_update()
{
  read -n1 -p "Update package source? (y/N) " ans
  if [[ $ans =~ [Yy] ]]; then
    sudo apt-get update
  fi
}

function pkg_cleanall()
{
  sudo apt-get autoremove -y
  sudo apt-get autoclean
  sudo apt-get clean
}

function pkg_install()
{
  for i in $1
  do
    which $i > /dev/null 2>&1
    if [ $? -ne 0 ]; then
      ret='1'
      error "Check '$i' : Fail. Try to install it automatically!"

      sudo apt-get install $1 --allow-unauthenticated -y || error "Installation of '$i' failure, please install it manually!"
    else
      ret='0'
      success "Check '$i' : Success!"
    fi
  done
}

function tmux_install()
{
  pkg_install "libevent-dev libcurses-ocaml-dev"
  # which tmux > /dev/null
  # if [[ $? -ne 0 ]]; then
  #   if [[ ! -d "./temp/tmux" ]]; then
  #     cd temp
  #     echo "get latest tmux from internet then build and install"
  #     git clone https://github.com/tmux/tmux && cd tmux && ./autogen.sh && ./configure && make && sudo make install || ( echo "Error occured!exit.";exit 3 )
  #   fi
  #   cd ${APP_PATH}
  # fi
}

# -----------------------------------------------
# vim:fdm=marker
