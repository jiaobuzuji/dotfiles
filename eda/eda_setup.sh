#!/usr/bin/env bash

# -----------------------------------------------------------------
# Author : Jiaobuzuji@163.com
# Reference : https://github.com/tracyone/dotfiles/
# -----------------------------------------------------------------

# SETUP FUNCTIONS {{{1
# -----------------------------------------------------------------
function msg() { # {{{2
    printf '%b\n' "$1" >&2
}

function success() { # {{{2
    if [ "$ret" -eq '0' ]; then
        msg "\33[32m[✔]\33[0m ${1}${2}"
    fi
}

function centos_xfce() { # {{{2
  read -n1 -p "Install xface ? (y/N) " ans
  if [[ $ans =~ [Yy] ]]; then
    # sudo yum install -y epel-release
    sudo yum group install -y "X Window system" Xfce
    # sudo systemctl set-default multi-user.target # command login
    sudo systemctl set-default graphical.target # ui login
    # sudo systemctl isolate graphical.target # start ui now
    # startxface4 # or `init 5`

    sudo sed -i -e "s#ONBOOT=.*#ONBOOT=yes#g" \
                   /etc/sysconfig/network-scripts/ifcfg-e* # Activate ethernet while booting

  else
    printf '\n' >&2
  fi
}

# Environment {{{1
[ -z "$REPO_PATH" ] && REPO_PATH="$HOME/repos"
[ -z "$CURR_PATH" ] && CURR_PATH=$(pwd)

# Install Packages {{{1
# -----------------------------------------------------------------

if [ $0 = "x" ]; then
  pkg_clean
  exit 1
else
fi
pkg_clean

# echo "haha" # DEBUG

# -----------------------------------------------------------------
# vim:fdm=marker
