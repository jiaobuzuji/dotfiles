#!/usr/bin/env bash

# -----------------------------------------------------------------
# Author : Jiaobuzuji@163.com
# Reference : https://github.com/tracyone/dotfiles/
# Abstract : ubuntu bootstrap functions
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

function centos_mirror() { # {{{2
  read -n1 -p "Software Source ? (y/N) " ans
  if [[ $ans =~ [Yy] ]]; then
    sudo yum remove -y epel-release
    sudo yum clean all
    sudo rm -rf /var/cache/yum
    sudo mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak # backup
    sudo curl -o /etc/yum.repos.d/CentOS-Base.repo -fsSL http://mirrors.aliyun.com/repo/Centos-7.repo # TODO CentOS 7
    sudo curl -o /etc/yum.repos.d/epel-7.repo -fsSL http://mirrors.aliyun.com/repo/epel-7.repo # TODO CentOS 7
    sudo yum makecache
    sudo yum update
    sudo rm -f /tmp/yum_save_tx* # clean log
  else
    printf '\n' >&2
  fi
}

function centos_xface() { # {{{2
  read -n1 -p "Install xface ? (y/N) " ans
  if [[ $ans =~ [Yy] ]]; then
    # sudo yum install -y epel-release
    sudo yum groupinstall -y "X Window system"
    sudo yum groupinstall -y xface
    sudo systemctl isolate graphical.target
    # systemctl set-default multi-user.target # command login
    systemctl set-default graphical.target # ui login
    # startxfce4
  else
    printf '\n' >&2
  fi
}

function pkg_update() { # {{{2
  read -n1 -p "Update system ? (y/N) " ans
  if [[ $ans =~ [Yy] ]]; then
    sudo yum clean all
    sudo yum makecache
    sudo yum install -y epel-release
    sudo yum -y update
  else
    printf '\n' >&2
  fi
}

function pkg_install() { # {{{2
  for i in $1
  do
    which $i > /dev/null 2>&1
    if [ $? -ne 0 ]; then
      ret='1'
      msg "Check '$i' : Fail. Try to install it automatically!"
      sudo yum install $i -y || error "Installation of '$i' failure, please install it manually!"
    else
      ret='0' && success "Check '$i' : Success!"
    fi
  done
}

function pkg_group_basic() { # {{{2
  # sudo yum groups install "Development Tools"
  pkg_install "gcc gcc-c++ automake autoconf cmake wget ctags cscope clang libgcc libcxx"
  pkg_install "redhat-lsb kernel-devel openssh-server firefox tree zip xclip"
  pkg_install "libcurl-devel zlib-devel"
  # pkg_install "libgnome-devel libgnomeui-devel" # gnome ui
  pkg_install "gtk3-devel" # gtk2-devel"
  pkg_install "texinfo texi2html" # zsh
  pkg_install "libX11-devel ncurses-devel libXpm-devel libXt-devel" # vim
  pkg_install "libevent-devel" # tmux

  pkg_install "perl-devel"
  pkg_install "tcl-devel"
  # pkg_install "lua lua-devel luajit luajit-devel"
  # pkg_install "ruby ruby-devel"
  pkg_install "python36 python36-devel" # python3-pip" # TODO CentOS 7
  sudo ln -sf /usr/bin/python3.6 /usr/bin/python3 # TODO CentOS 7

  pkg_install "fontconfig mkfontscale mkfontdir" # font tools
  pkg_install "im-chooser gtk3-immodule-xim ibus ibus-gtk3 ibus-table-chinese-wubi-jidian" # input method
  imsettings-switch ibus # current user
  sudo imsettings-switch ibus # root
}

function pkg_gcc() { # {{{2
  pkg_install "libmpc-devel mpfr-devel gmp-devel zlib-devel"
  pkg_install "texinfo flex"
  # mkdir -p "$HOME/repos/gcc" && cd "$HOME/repos/gcc"
  # cd $CURR_PATH
}

function pkg_git() { # {{{2
  # if [ -x "$(which git)" ];
  which git > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    read -n1 -p "'git' has already in system. Do you want to reinstall it ? (y/N) " ans
    [[ $ans =~ [Yy] ]] && sudo yum remove git -y || return 1
  fi

  mkdir -p "$HOME/repos/git" && cd "$HOME/repos/git"
  if [[ ! -d "$HOME/repos/git/v2.19.1"  ]]; then # TODO 20181008
    wget -c "https://github.com/git/git/archive/v2.19.1.tar.gz" && tar -zxf "v2.19.1.tar.gz"
  fi
  cd "git-2.19.1"

  pkg_install "gcc gcc-c++ automake autoconf expat-devel openssl-devel zlib-devel perl-ExtUtils-MakeMaker asciidoc xmlto texinfo docbook2X"
  sudo ln -sf /usr/bin/db2x_docbook2texi /usr/bin/docbook2x-texi
  sudo make uninstall # uninstall
  sudo make clean distclean
  make prefix=/usr all doc info
  if [ $? -eq 0 ]; then
    sudo make prefix=/usr install install-doc install-html install-info
  fi
  cd $CURR_PATH
}

function pkg_vim() { # {{{2
  which vim > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    read -n1 -p "'vim' has already in system. Do you want to reinstall it ? (y/N) " ans
    [[ $ans =~ [Yy] ]] && sudo yum remove vim-common vim-enhanced -y || return 1
  fi

  if [ ! -e "$HOME/repos/vim.git" ]; then
      git clone --depth 1 "https://github.com/vim/vim" "$HOME/repos/vim.git" && \
      cd "$HOME/repos/vim.git"
  else
      cd "$HOME/repos/vim.git" && git pull
  fi

  # pkg_install "libgnome-devel libgnomeui-devel"
  pkg_install "libX11-devel ncurses-devel libXpm-devel libXt-devel libattr-devel"
  pkg_install "perl perl-devel perl-ExtUtils-ParseXS \
               perl-ExtUtils-XSpp perl-ExtUtils-CBuilder \
               perl-ExtUtils-Embed perl-YAML"

  wget -c "https://raw.githubusercontent.com/jiaobuzuji/dotfiles/master/linux/centos_myvim.sh" # TODO
  source centos_myvim.sh

  cd $CURR_PATH
}

# Environment {{{1
[ -z "$REPO_PATH" ] && REPO_PATH="$HOME/repos"
[ -z "$CURR_PATH" ] && CURR_PATH=$(pwd)

# Install Packages {{{1
# -----------------------------------------------------------------
# If you are minimal CentOS, you must make internet work first.
# Command `nmcli d` to display ethernet status.
# Command `nmtui` to activate ethernet.

# centos_mirror
pkg_update
pkg_group_basic
# pkg_gcc
pkg_git
pkg_vim

# echo "haha" # DEBUG

# -----------------------------------------------------------------
# vim:fdm=marker
