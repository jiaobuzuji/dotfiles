#! /usr/bin/env bash

# -----------------------------------------------
# Author : Jiaobuzuji@163.com
# Reference : https://github.com/tracyone/dotfiles/
# Reference : https://github.com/spf13/spf13-vim/blob/3.0/bootstrap.sh
# -----------------------------------------------

# BASIC SETUP TOOLS (functions) {{{1
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
      error "Check package '$i' FAIL.Please install it manually!"
    else
      ret='0'
      success "Check package '$i' successfully!"
    fi
  done
}


# SETUP FUNCTIONS {{{1
function sync_repo() {
    local repo_path="$1"
    local repo_uri="$2"
    local repo_branch="$3"
    local repo_name="$4"

    msg "Trying to update $repo_name"

    if [ ! -e "$repo_path" ]; then
        mkdir -p "$repo_path"
        git clone --depth=1 -b "$repo_branch" "$repo_uri" "$repo_path"
        ret="$?"
        success "Successfully cloned $repo_name."
    else
        cd "$repo_path" && git pull origin "$repo_branch"
        ret="$?"
        success "Successfully updated $repo_name"
    fi
    debug
}

# MAIN() {{{1
# Environment message
msg "\nOS Kernel is `uname`"
msg "`lsb_release -d`\n"

# install packages
linux_distributor=$(lsb_release -i | cut -f2)

if [ $linux_distributor == "Ubuntu" ]; then
  pkg_check "apt-get"
  # source ubuntu
elif [ $linux_distributor == "Centos" ]; then
  pkg_check "yum"
else
  msg "Not support this distributor."
  msg "Copyright © `date +%Y`  http://www.jiaobuzuji.com/"
  exit 1
fi

# install vim
# sync_repo       "$APP_PATH" \
#                 "$REPO_URI" \
#                 "$REPO_BRANCH" \
#                 "$app_name"

# lnif "$source_path/.vimrc.before"  "$target_path/.vimrc.before"

msg "\nThanks for installing ."
msg "Copyright © `date +%Y`  http://www.jiaobuzuji.com/"


# -----------------------------------------------
# vim:fdm=marker
