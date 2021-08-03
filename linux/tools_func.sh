#!/usr/bin/env bash

# -----------------------------------------------------------------
# Author : Jiaobuzuji@163.com
# Reference : https://github.com/tracyone/dotfiles/
# Abstract : tools functions
# -----------------------------------------------------------------

function tools_autojump() {
  # pkg_install "autojump autojump-zsh" # CentOS
  # pkg_install "autojump" # Ubuntu

  if [ -e "$REPO_PATH/autojump.git" ]; then
    cd "$REPO_PATH/autojump.git"
    sudo ./uninstall.py
  fi

  repo_sync  "$REPO_PATH" \
    "https://github.com/wting/autojump" \
    "master" \
    "autojump.git"

  # ./install.py  # for current user
  cd "$REPO_PATH/autojump.git" && sudo ./install.py -s # for all users
  cd $CURR_PATH
}


function tools_zsh() {
  # pkg_install "zsh zsh-doc" # zsh
  # pkg_install "texinfo texi2html yodl" # zsh-doc dependencies

  if [ -e "$REPO_PATH/zsh.git" ]; then
    cd "$REPO_PATH/zsh.git"
    sudo make uninstall # uninstall
    sudo make clean distclean
  fi

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
  cd $CURR_PATH
}

function tools_tmux() {
  # pkg_install "tmux"
  # pkg_install "libevent-dev libcurses-ocaml-dev" # Ubuntu

  if [ -e "$REPO_PATH/tmux.git" ]; then
    cd "$REPO_PATH/tmux.git"
    sudo make uninstall # uninstall
    sudo make clean distclean
  fi

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
  cd $CURR_PATH
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
  mkdir -p "$HOME/.vim/undodir"

  curl -fLo ${HOME}/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  repo_sync  "${HOME}/.vim/bundle" \
             "https://github.com/Valloric/YouCompleteMe/" \
             "master" \
             "YouCompleteMe"

  cd  ${HOME}/.vim/bundle/YouCompleteMe
  git submodule update --init --recursive && python3 ./install.py --clang-completer || return 1 # TODO

  vim +'PlugInstall' +':q'
  cd $CURR_PATH
}

function tools_fonts() {
  repo_sync  "$REPO_PATH" \
             "https://github.com/tracyone/program_font" \
             "master" \
             "program_font"

  sudo ln -sfT  "$REPO_PATH/program_font"   "/usr/share/fonts/program_font"
  cd "/usr/share/fonts/program_font"
  # sudo mkfontscale
  # sudo mkfontdir
  sudo fc-cache -fv
  cd $CURR_PATH
}

function tools_rar() {
  read -n1 -p "Install rar ? (y/N) " ans
  if [[ $ans =~ [Yy] ]]; then
    local pkg_version="5.6.1" # TODO 20181008
    mkdir -p ${HOME}/repos/rar/ && cd ${HOME}/repos/rar/
    msg "Downloading rar !"
    curl -OfSL https://www.rarlab.com/rar/rarlinux-x64-${pkg_version}.tar.gz
    tar -xzvf rarlinux-x64-${pkg_version}.tar.gz
    cd rar
    sudo make

    # uninstall
    # vim makefile

    cd $CURR_PATH
  else
    printf '\n' >&2
  fi
}

# -----------------------------------------------------------------
# vim:fdm=marker
