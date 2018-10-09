#!/usr/bin/env bash

# -----------------------------------------------------------------
# Author : Jiaobuzuji@163.com
# Reference : https://github.com/tracyone/dotfiles/
# Abstract : tools functions
# -----------------------------------------------------------------

function tools_autojump() {
  local current_pwd=`pwd`

  # pkg_install "autojump autojump-zsh" # CentOS
  # pkg_install "autojump" # Ubuntu

  sudo ./uninstall.py

  repo_sync  "$REPO_PATH" \
    "https://github.com/wting/autojump" \
    "master" \
    "autojump.git"

  # ./install.py  # for current user
  cd "$REPO_PATH/autojump.git" && sudo ./install.py -s # for all users
  cd $current_pwd
}


function tools_zsh() {
  local current_pwd=`pwd`
  # pkg_install "zsh zsh-doc" # zsh
  # pkg_install "texinfo texi2html yodl" # zsh-doc dependencies

  sudo make uninstall
  sudo make clean distclean

  repo_sync  "$REPO_PATH" \
             "https://github.com/zsh-users/zsh/" \
             "master" \
             "zsh.git"
  cd "$REPO_PATH/zsh.git"
  git checkout $(git describe --tags `git rev-list --tags --max-count=1`)
  ./Util/preconfig
  ./configure --prefix=/usr

  if [ $? -eq 0 ]; then
    make
    # sudo checkinstall # package for Debain linux
    sudo make install
  fi

  if [ -z "$ZSH_VERSION" ]; then
    [ ! -z $(grep '/usr/bin/zsh' '/etc/shells') ] || sudo sed -i '$a\/usr/bin/zsh' '/etc/shells'
    msg "Please enter CURRENT USER's password for changing shell."
    chsh -s /usr/bin/zsh # current user
    # chsh -s $(which zsh) or chsh -s `which zsh` or chsh -s /bin/zsh, and restart shell
  fi

  repo_sync  "$REPO_PATH" \
    "https://github.com/robbyrussell/oh-my-zsh" \
    "master" \
    "oh-my-zsh.git"
  # cd oh-my-zsh/tools && ./install.sh || ( echo "Error occurred!exit.";exit 3 )
  # curl -L git.io/antigen > antigen.zsh
  cd $current_pwd
}

function tools_tmux() {
  local current_pwd=`pwd`
  # pkg_install "tmux"
  # pkg_install "libevent-dev libcurses-ocaml-dev" # Ubuntu

  sudo make uninstall
  sudo make clean distclean

  repo_sync  "$REPO_PATH" \
    "https://github.com/tmux/tmux" \
    "master" \
    "tmux.git"
  cd "$REPO_PATH/tmux.git"
  git checkout $(git describe --tags `git rev-list --tags --max-count=1`)

  ./autogen.sh
  ./configure --prefix=/usr

  if [ $? -eq 0 ]; then
    make
    # sudo checkinstall # package for Debain linux
    sudo make install
  fi
  cd $current_pwd
}

function tools_rg_ag() {
  which 'ag' > /dev/null 2>&1
  if [ $? -ne 0 ]; then
    if [ -e "/etc/centos-release" ]; then # CentOS
      sudo yum install -y the_silver_searcher
    else
      sudo apt install -y silversearcher-ag # Ubuntu
    fi
  fi

  which 'rg' > /dev/null 2>&1
  [ $? -ne 0 ] && [ ! -e "/etc/centos-release" ] && sudo snap install rg # Ubuntu
}


function tools_vim() {
  repo_sync  "$REPO_PATH" \
             "https://github.com/jiaobuzuji/vimrc" \
             "master" \
             "vimrc.git"

  lnif "$REPO_PATH/vimrc.git"   "$HOME/.vim"

  curl -fLo ${HOME}/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  gvim +PlugInstall
}

# function tools_fonts() {
  # local current_pwd=`pwd`
  # if [ $linux_distributor == "CentOS" ]; then
  # pkg_install "fontconfig mkfontscale" #
  # fi
  # sudo mkdir -p /usr/share/fonts/yahei
  # sudo cp YaHei.Consolas.1.12.ttf /usr/share/fonts/yahei/
  # 然后，改变权限：
  # sudo chmod 644 /usr/share/fonts/yahei/YaHei.Consolas.1.12.ttf
  # 安装：
  # cd /usr/share/fonts/yahei/
  # sudo mkfontscale
  # sudo mkfontdir
  # sudo fc-cache -fv
  # cd $current_pwd
# }


# -----------------------------------------------------------------
# vim:fdm=marker
