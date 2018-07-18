#! /usr/bin/env bash

# -----------------------------------------------------------------
# Author : Jiaobuzuji@163.com
# Reference : https://github.com/tracyone/dotfiles/
# Reference : https://github.com/spf13/spf13-vim/blob/3.0/bootstrap.sh
# Abstract : bootstrap
# -----------------------------------------------------------------


# BASIC SETUP TOOLS (functions) {{{1
# -----------------------------------------------------------------
function msg() {
    printf '%b\n' "$1" >&2
}

function success() {
    if [ "$ret" -eq '0' ]; then
        msg "\33[32m[✔]\33[0m ${1}${2}"
    fi
}

function error() {
    msg "\33[31m[✘]\33[0m ${1}${2}"
    exit 1
}

function debug() {
    if [ "$ret" -gt '1' ]; then
        msg "An error occurred in function \"${FUNCNAME[$i+1]}\" on line ${BASH_LINENO[$i+1]}, we're sorry for that."
    fi
}

function lnif() {
    if [ -e "$1" ]; then
        ln -sf "$1" "$2"
    fi
    ret="$?"
    debug
}

function pkg_check()
{
  for i in $1
  do
    which $i > /dev/null 2>&1
    if [ $? -ne 0 ]; then
      ret='1'
      error "Check '$i' : Fail. Please install it manually!"
    else
      ret='0'
      success "Check '$i' : Success!"
    fi
  done
}



# SETUP FUNCTIONS {{{1
# -----------------------------------------------------------------
# repo_sync (repo_path, repo_uri, repo_branch, repo_name)
function repo_sync() {
    local repo_path="$1"
    local repo_uri="$2"
    local repo_branch="$3"
    local repo_name="$4"

    msg "Trying to clone or update '$repo_name' repository."

    if [ ! -e "$repo_path/$repo_name" ]; then
        git clone --depth 1 -b "$repo_branch" "$repo_uri" "$repo_path/$repo_name"
        # git clone "$repo_uri" "$repo_path/$repo_name"
        ret="$?"
        success "Successfully cloned '$repo_name'."
    else
        cd "$repo_path/$repo_name" && git pull origin "$repo_branch"
        ret="$?"
        success "Successfully updated '$repo_name'"
    fi
    msg ""
    debug
}


# MAIN() {{{1
# -----------------------------------------------------------------
# Environment {{{2
msg "\nOS Kernel : `uname`"
msg "`lsb_release -d`\n"

[ -z "$REPO_PATH" ] && REPO_PATH="$HOME/repos"


# Install basic packages {{{2
linux_distributor=$(lsb_release -si) # $(lsb_release -i | cut -f2)

# Ubuntu
if [ $linux_distributor == "Ubuntu" ]; then
  pkg_check "apt-get git"
  repo_sync  "$REPO_PATH" \
             "https://github.com/jiaobuzuji/dotfiles" \
             "master" \
             "dotfiles.git"
  source "$REPO_PATH/dotfiles.git/linux/ubuntu_func.sh"
  # [ ! -f "${HOME}/.myshell/extra.sh" ] && echo -ne "alias which='which -a'" > "${HOME}/.myshell/extra.sh"

# CentOS
elif [ $linux_distributor == "CentOS" ]; then
  pkg_check "yum git"
  repo_sync  "$REPO_PATH" \
             "https://github.com/jiaobuzuji/dotfiles" \
             "master" \
             "dotfiles.git"
  source "$REPO_PATH/dotfiles.git/linux/centos_func.sh"
  pkg_install "epel-release"
  tools_git

# Others
else
  error "Not support this distributor."
  msg "Copyright © `date +%Y`  http://www.jiaobuzuji.com/"
  exit 1
fi

pkg_update # Before update packages, You should change source.
pkg_install "autoconf automake curl wget grep"
source "$REPO_PATH/dotfiles.git/linux/tools_func.sh"
msg ""
# exit 1 # DEBUG


# Awesome tools {{{2
tools_autojump
tools_zsh
tools_tmux
# tools_rg_ag
# tools_vim
# tools_fonts
# exit 1 # DEBUG


# Create Links {{{2
mkdir -p ${HOME}/{.ssh,.vnc}
lnif "$REPO_PATH/dotfiles.git/shell"   "$HOME/.myshell"
lnif "$REPO_PATH/dotfiles.git/shell/.zshrc"   "$HOME/.zshrc"
# lnif "$REPO_PATH/dotfiles.git/shell/.bashrc"   "$HOME/.bashrc"
# lnif "$REPO_PATH/dotfiles.git/shell/.bash_profile"   "$HOME/.bash_profile"
# lnif "$REPO_PATH/dotfiles.git/shell/.bash_aliases"   "$HOME/.bash_aliases"
lnif "$REPO_PATH/dotfiles.git/git/.gitconfig"   "$HOME/.gitconfig"
lnif "$REPO_PATH/dotfiles.git/tmux/.tmux.conf"   "$HOME/.tmux.conf"
# lnif "$REPO_PATH/dotfiles.git/ssh/config"   "$HOME/.ssh/config"


# Finish {{{2
msg "\nThanks for installing ."
msg "Copyright © `date +%Y`  http://www.jiaobuzuji.com/"


# -----------------------------------------------------------------
# vim:fdm=marker
