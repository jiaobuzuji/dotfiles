#! /usr/bin/env bash

# -----------------------------------------------
# Author : Jiaobuzuji@163.com
# Reference : https://github.com/tracyone/dotfiles/
# Abstract : ubuntu bootstrap functions
# -----------------------------------------------

# function pkg_mirror()
# {
# }

function pkg_cleanall()
{
  sudo yum clean all
  sudo yum cleanup
}

function pkg_update()
{
  read -n1 -p "Update package source? (y/N) " ans
  if [[ $ans =~ [Yy] ]]; then
    pkg_cleanall
    sudo yum makecache
    sudo yum update
  fi
}

function pkg_install()
{
  for i in $1
  do
    which $i > /dev/null 2>&1
    if [ $? -ne 0 ]; then
      ret='1'
      error "Check '$i' : Fail. Try to install it automatically!"

      sudo yum install $1 -y || error "Installation of '$i' failure, please install it manually!"
    else
      ret='0'
      success "Check '$i' : Success!"
    fi
  done
}

function tmux_install()
{
  pkg_install "libevent2-devel"
  # which tmux > /dev/null
  # if [[ $? -ne 0 ]]; then
  #   if [[ ! -d "./temp/tmux" ]]; then
  #     cd temp
  #     echo "get latest tmux from internet then build and install"
  #     git clone https://github.com/tmux/tmux && cd tmux && ./autogen.sh && ./configure && make && sudo make install || ( echo "Error occured!exit.";exit 3 )
  #   fi
  #   cd ${APP_PATH}
  # fi
  # pkg_install "tmux" # install manual
}

function git_install()
{
  # sync_repo  "$REPO_PATH" \
  #            "https://github.com/git/git/" \
  #            "v2.16.1" \
  #            "git.git"
  # sync_repo  "$REPO_PATH" \
  #            "https://github.com/git/git/" \
  #            "master" \
  #            "git.git"
  cur_dir=$(pwd)
  mkdir -p "$REPO_PATH/git.release"
  cd "$REPO_PATH/git.release"
  wget -c "https://github.com/git/git/archive/v2.16.1.tar.gz"
  tar -zxf "v2.16.1.tar.gz"
  cd "v2.16.1"
  pkg_install "asciidoc xmlto texinfo docbook2X" # CentOS
  # pkg_install "wget curl-devel expat-devel gettext-devel openssl-devel zlib-devel perl-ExtUtils-MakeMaker gcc"
  # ln -s /usr/bin/db2x_docbook2texi /usr/bin/docbook2x-texi
  # make prefix=/usr all doc info 
  # if [ $? -eq 0 ]; then
  # sudo make prefix=/usr install install-doc install-html install-info

  cd "${cur_dir}"
}

# -----------------------------------------------
# vim:fdm=marker
