#! /usr/bin/env bash

# -----------------------------------------------------------------
# Author : Jiaobuzuji@163.com
# Reference : https://github.com/tracyone/dotfiles/
# Reference : https://github.com/spf13/spf13-vim/blob/3.0/bootstrap.sh
# Abstract : basic functions
# -----------------------------------------------------------------


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

# -----------------------------------------------------------------
# vim:fdm=marker
