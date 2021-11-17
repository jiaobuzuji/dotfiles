#!/usr/bin/env bash

# -----------------------------------------------------------------
# Author : Jiaobuzuji@163.com
# Reference : https://github.com/tracyone/dotfiles/
# Abstract : tools functions
# -----------------------------------------------------------------

# BASIC SETUP TOOLS (functions) {{{1
# -----------------------------------------------------------------
function tools_autojump() {
  # pkg_install "autojump autojump-zsh" # CentOS
  # pkg_install "autojump" # Ubuntu

  if [ -e "${REPO_PATH}/autojump.git" ]; then
    cd "${REPO_PATH}/autojump.git"
    sudo ./uninstall.py
  fi

  repo_sync  "${REPO_PATH}" \
    "https://${GITSRVURL}/wting/autojump" \
    "master" \
    "autojump.git"

  # ./install.py  # for current user
  cd "${REPO_PATH}/autojump.git" && sudo ./install.py -s # for all users
  cd ${CURR_PATH}
}


function tools_zsh() {
  # pkg_install "zsh zsh-doc" # zsh
  # pkg_install "texinfo texi2html yodl" # zsh-doc dependencies

  if [ -e "${REPO_PATH}/zsh.git" ]; then
    cd "${REPO_PATH}/zsh.git"
    sudo make uninstall # uninstall
    sudo make clean distclean
  fi

  repo_sync  "${REPO_PATH}" \
             "https://${GITSRVURL}/zsh-users/zsh/" \
             "master" \
             "zsh.git"
  cd "${REPO_PATH}/zsh.git"
  git checkout $(git describe --tags `git rev-list --tags --max-count=1`)
  ./Util/preconfig
  ./configure --prefix=/usr

  if [ $? -eq 0 ]; then
    make -j$(nproc)
    # sudo checkinstall # package for Debain linux
    sudo make install
  fi

  if [ -z "$ZSH_VERSION" ]; then
    [ ! -z $(grep '/usr/bin/zsh' '/etc/shells') ] || sudo sed -i '$a\/usr/bin/zsh' '/etc/shells'
    msg "Please enter CURRENT USER's password for changing shell."
    chsh -s /usr/bin/zsh # current user
    # chsh -s $(which zsh) or chsh -s `which zsh` or chsh -s /bin/zsh, and restart shell
  fi

  repo_sync  "${REPO_PATH}" \
    "https://${GITSRVURL}/ohmyzsh/ohmyzsh" \
    "master" \
    "ohmyzsh.git"
  # cd ohmyzsh.git/tools && ./install.sh || ( echo "Error occurred!exit.";exit 3 )
  # curl -L git.io/antigen > antigen.zsh
  cd ${CURR_PATH}
}

function tools_tmux() {
  # pkg_install "tmux"
  # pkg_install "libevent-dev libcurses-ocaml-dev" # Ubuntu

  if [ -e "${REPO_PATH}/tmux.git" ]; then
    cd "${REPO_PATH}/tmux.git"
    sudo make uninstall # uninstall
    sudo make clean distclean
  fi

  repo_sync  "${REPO_PATH}" \
    "https://${GITSRVURL}/tmux/tmux" \
    "master" \
    "tmux.git"
  cd "${REPO_PATH}/tmux.git"
  git checkout $(git describe --tags `git rev-list --tags --max-count=1`)

  ./autogen.sh
  ./configure --prefix=/usr

  if [ $? -eq 0 ]; then
    make -j$(nproc)
    # sudo checkinstall # package for Debain linux
    sudo make install
  fi
  cd ${CURR_PATH}
}

function tools_rg_ag_fd() {
  which 'ag' > /dev/null 2>&1
  if [ $? -ne 0 ]; then
    if [ -e "/etc/centos-release" ]; then # CentOS
      sudo yum install -y the_silver_searcher
      # rg 0 (deprecated)
      # sudo yum install https://extras.getpagespeed.com/release-el7-latest.rpm # Install GetPageSpeed repository:
      # sudo yum install ripgrep --enablerepos= xxxx # Install ripgrep rpm package:
      # rg 1 (recommend)
      # curl -OfSL https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep-13.0.0-x86_64-unknown-linux-musl.tar.gz
      # tar -xvf ripgrep-13.0.0-x86_64-unknown-linux-musl.tar.gz
      # sudo mv ripgrep-13.0.0-x86_64-unknown-linux-musl/rg /usr/bin/
      # rg 2
      # sudo yum install snapd
      # sudo systemctl enable --now snapd.socket
      # sudo ln -s /var/lib/snapd/snap /snap # NOTE !! Log Out for update "PATH"
      # sudo snap install ripgrep --classic
      # fd 1 (recommend)
      # curl -OfSL https://github.com/sharkdp/fd/releases/download/v8.2.1/fd-v8.2.1-x86_64-unknown-linux-musl.tar.gz
      # tar -xvf fd-v8.2.1-x86_64-unknown-linux-musl.tar.gz
      # sudo mv fd-v8.2.1-x86_64-unknown-linux-musl.tar.gz /usr/bin/
    else # Ubuntu
      sudo apt install -y silversearcher-ag
      sudo apt install -y fd-find
      # curl -LO  https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
      # sudo dpkg -i ripgrep_13.0.0_amd64.deb
    fi
  fi

  # which 'rg' > /dev/null 2>&1
  # [ $? -ne 0 ] && [ ! -e "/etc/centos-release" ] && sudo snap install rg # Ubuntu
}


function tools_fonts() {
  repo_sync  "${REPO_PATH}" \
             "https://${GITSRVURL}/tracyone/program_font" \
             "master" \
             "program_font"

  sudo ln -sfT  "${REPO_PATH}/program_font"   "/usr/share/fonts/program_font"
  cd "/usr/share/fonts/program_font"
  # sudo mkfontscale
  # sudo mkfontdir
  sudo fc-cache -fv
  cd ${CURR_PATH}
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
    sudo make -j$(nproc)

    # uninstall
    # vim makefile

    cd ${CURR_PATH}
  else
    printf '\n' >&2
  fi
}

# Environment {{{1
# -----------------------------------------------------------------
[ -z "${REPO_PATH}" ] && REPO_PATH="${HOME}/repos"
[ -z "${CURR_PATH}" ] && CURR_PATH=$(pwd)
[ -z "${GITSRVURL}" ] && GITSRVURL="github.com" # mirror0: github.com.cnpmjs.org   mirror1: gitee.com(not work)

# -----------------------------------------------------------------
# vim:fdm=marker
