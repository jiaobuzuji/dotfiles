#!/usr/bin/env bash

# -----------------------------------------------------------------
# Author : Jiaobuzuji@163.com
# Reference : https://github.com/tracyone/dotfiles/
# Abstract : bootstrap functions
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
    sudo curl -o /etc/yum.repos.d/CentOS-Base.repo -fSL http://mirrors.aliyun.com/repo/Centos-7.repo # TODO CentOS 7
    # sudo curl -o /etc/yum.repos.d/epel-7.repo -fSL http://mirrors.aliyun.com/repo/epel-7.repo # TODO CentOS 7
    sudo yum makecache
    sudo yum -y update
    # sudo yum -y upgrade
    sudo rm -f /tmp/yum_save_tx* # clean log
    sudo yum install -y epel-release
  else
    printf '\n' >&2
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

    # https://wiki.xfce.org/recommendedapps
    pkg_install "xfce4-about xarchiver xfce4-screenshooter xfce4-screenshooter-plugin"
    pkg_install "xfdashboard xfce4-mount-plugin"
    pkg_install "system-config-users system-config-language system-config-printer"
    pkg_install "xfce4-taskmanager gnome-system-monitor gnome-system-log" # monitor
    pkg_install "xfce4-battery-plugin xbacklight" # power, brightness

    pkg_install "usermode-gtk" # users information
    pkg_install "evince" # pdf
    pkg_install "ristretto" # xfce image viewer
    # pkg_install "eog" # gnome image viewer
    pkg_install "firewall-config"
    pkg_install "vinagre" # remote desktop viewer
    pkg_install "seahorse" # key manager
    pkg_install "gnome-disk-utility baobab" # disk modifier & analyzer (udisksctl, mkfs.ext4)
    pkg_install "gnome-calculator" # calculator

    pkg_install "xfdashboard-themes xfwm4-themes arc-theme arc-theme-plank" # themes https://www.xfce-look.org/
    # pkg_install "numix-gtk-theme numix-icon-theme"

    sudo xbacklight -set 8 # for laptop
    sudo sed -i -e "s#ONBOOT=.*#ONBOOT=yes#g" \
                   /etc/sysconfig/network-scripts/ifcfg-e* # Activate ethernet while booting

    # xfce4-session-settings
    # Select Application Autostart
    # SSH Key Agent (GNOME Keyring:SSH agent)
    # Select Advanced
    # Check Launch GNOME services on startup

    # GDM (GNOME Display Manage) autologin
    # vi /etc/gdm/custom.conf
    # [daemon]
    # AutomaticLoginEnable=True
    # AutomaticLogin=MyName  # user name

  else
    printf '\n' >&2
  fi
}

function centos_hostname() { # {{{2
  echo "Modify \"hostname\" ? Please use method 2 ."
  cat << ECHO_END
  # method 1
  # vi /etc/hosts

  # method 2
  # hostnamectl status [--static|--transient|--pretty]
  # hostnamectl set-hostname MY_NAME
  # cat /etc/machine-info

  # method 3
  # nmcli general hostname MY_NAME
  # nmtui-hostname

  # method 4
  # vi /etc/sysconfig/network

  # method 5 # temporary
  # hostname MY_NAME
ECHO_END

}


function pkg_addition() { # {{{2
  sudo yum install -y http://linuxdownload.adobe.com/linux/x86_64/adobe-release-x86_64-1.0-1.noarch.rpm # flash player

  # sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm # epel-release TODO CentOS 7
  sudo yum install -y https://download1.rpmfusion.org/free/el/rpmfusion-free-release-7.noarch.rpm # vlc TODO CentOS 7

  # rpm -i http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-xxxx.rpm # Fail !!
  # rpm -Uvh http://download.fedoraproject.org/pub/epel/xxxx.rpm

  cd /etc/yum.repos.d/
  msg "Getting virtualbox repo !"
  sudo curl -OfSL http://download.virtualbox.org/virtualbox/rpm/rhel/virtualbox.repo # vbox

  cd $CURR_PATH
}

function pkg_update() { # {{{2
  read -n1 -p "Update system ? (y/N) " ans
  if [[ $ans =~ [Yy] ]]; then
    sudo yum remove -y epel-release
    sudo yum clean all
    sudo rm -rf /var/cache/yum
    sudo yum makecache
    sudo yum -y update
    # sudo yum -y upgrade
    # yum --enablerepo=rpmforge-extras update # use rpmforge source
    sudo rm -f /tmp/yum_save_tx* # clean log
    sudo yum install -y epel-release
  else
    printf '\n' >&2
  fi
}

function pkg_install() { # {{{2
  sudo yum install -y $1
  # for i in $1
  # do
  #   which $i > /dev/null 2>&1
  #   if [ $? -ne 0 ]; then
  #     ret='1'
  #     msg "Check '$i' : Fail. Try to install it automatically!"
  #     sudo yum install $i -y || error "Installation of '$i' failure, please install it manually!"
  #   else
  #     ret='0' && success "Check '$i' : Success!"
  #   fi
  # done
}

function pkg_group_basic() { # {{{2
  # sudo yum groups install -y "Development Tools"
  pkg_install "gcc gcc-c++ automake autoconf cmake wget ctags cscope clang csh libgcc libcxx"
  pkg_install "redhat-lsb kernel-devel openssh-server net-tools network-manager-applet"
  pkg_install "firefox bzip2 ntfs-3g ntfs-3g tree xclip"
  pkg_install "libcurl-devel zlib-devel"
  pkg_install "libgnome-devel libgnomeui-devel gtk3-devel gtk2-devel" # ui dependencies
  pkg_install "texinfo texi2html" # zsh
  pkg_install "libX11-devel ncurses-devel libXpm-devel libXt-devel" # vim
  pkg_install "libevent-devel" # tmux

  pkg_install "java"
  pkg_install "perl-devel"
  pkg_install "tcl-devel"
  # pkg_install "lua lua-devel luajit luajit-devel"
  # pkg_install "ruby ruby-devel"
  pkg_install "python36 python36-devel" # python3-pip" # TODO CentOS 7
  sudo ln -sf /usr/bin/python3.6 /usr/bin/python3 # TODO CentOS 7

  pkg_install "fontconfig mkfontscale mkfontdir" # font tools
  pkg_install "cjkuni-ukai-fonts " # fonts and font tools

  pkg_install "zip p7zip p7zip-doc p7zip-gui p7zip-plugins" # archive tools

  pkg_install "im-chooser imsettings-gsettings" # imsettings-xim" # input method setting

  # pkg_install "gtk2-immodules gtk3-immodules gtk2-immodule-xim gtk3-immodule-xim" # input method
  # pkg_install "ibus ibus-qt ibus-gtk2 ibus-gtk3 ibus-table-chinese-wubi-jidian" # ibus
  # ibus-setup # config ibus
  # imsettings-switch ibus
  # im-chooser

  pkg_install "fcitx fcitx-configtool fcitx-table-chinese" # fcitx
  # pkg_install "fcitx fcitx-qt4 fcitx-qt5 fcitx-configtool fcitx-table-chinese" # fcitx
  # imsettings-switch fcitx # current user
  # im-chooser

  pkg_install "flash-plugin"
  pkg_install "vlc"

}

function pkg_clean() { # {{{2
  read -n1 -p "Clean old kernel ? (y/N) " ans
  if [[ $ans =~ [Yy] ]]; then
    local old_kernels=$(rpm -q kernel kernel-devel kernel-headers | egrep -v $(uname -r))
    [ ! -z "$old_kernels" ] && sudo yum remove -y $old_kernels
  else
    printf '\n' >&2
  fi
}

function pkg_gcc() { # {{{2
  # read -n1 -p "Install VirtualBox ? (y/N) " ans
  # if [[ $ans =~ [Yy] ]]; then
  # else
  #   printf '\n' >&2
  # fi
  pkg_install "libmpc-devel mpfr-devel gmp-devel zlib-devel"
  pkg_install "texinfo flex"
  # mkdir -p "$REPO_PATH/gcc" && cd "$REPO_PATH/gcc"
  # cd $CURR_PATH
}

function pkg_git() { # {{{2
  read -n1 -p "Build git ? (y/N) " ans
  if [[ $ans =~ [Yy] ]]; then
    # if [ -x "$(which git)" ];
    which git > /dev/null 2>&1
    if [ $? -eq 0 ]; then
      read -n1 -p "'git' has already in system. Do you want to reinstall it ? (y/N) " ans
      [[ $ans =~ [Yy] ]] && sudo yum remove git -y || return 1
    fi

    local pkg_version="2.19.1" # TODO 20181008
    mkdir -p "$REPO_PATH/git" && cd "$REPO_PATH/git"
    if [[ ! -d "$REPO_PATH/git/git-${pkg_version}"  ]]; then
      msg "Downloading git source!"
      curl -OfSL "https://github.com/git/git/archive/v${pkg_version}.tar.gz" && tar -zxf "v${pkg_version}.tar.gz"
    fi
    cd "git-${pkg_version}"

    pkg_install "gcc gcc-c++ automake autoconf expat-devel openssl-devel zlib-devel perl-ExtUtils-MakeMaker asciidoc xmlto texinfo docbook2X"
    sudo ln -sf /usr/bin/db2x_docbook2texi /usr/bin/docbook2x-texi
    sudo make uninstall # uninstall
    sudo make clean distclean
    make prefix=/usr all doc info
    if [ $? -eq 0 ]; then
      sudo make prefix=/usr install install-doc install-html install-info
    fi
    cd $CURR_PATH
  else
    printf '\n' >&2
  fi
}

function pkg_vim() { # {{{2
  read -n1 -p "Build vim ? (y/N) " ans
  if [[ $ans =~ [Yy] ]]; then
    which vim > /dev/null 2>&1
    if [ $? -eq 0 ]; then
      read -n1 -p "'vim' has already in system. Do you want to reinstall it ? (y/N) " ans
      [[ $ans =~ [Yy] ]] && sudo yum remove vim-common vim-enhanced -y || return 1
    fi

    if [ ! -e "$REPO_PATH/vim.git" ]; then
        git clone --depth 1 "https://github.com/vim/vim" "$REPO_PATH/vim.git" && \
        cd "$REPO_PATH/vim.git"
    else
        cd "$REPO_PATH/vim.git" && git pull
    fi

    pkg_install "libgnome-devel libgnomeui-devel"
    pkg_install "libX11-devel ncurses-devel libXpm-devel libXt-devel libattr-devel"
    pkg_install "perl perl-devel perl-ExtUtils-ParseXS \
                 perl-ExtUtils-XSpp perl-ExtUtils-CBuilder \
                 perl-ExtUtils-Embed perl-YAML"

    curl -OfsSL "https://raw.githubusercontent.com/jiaobuzuji/dotfiles/master/linux/centos_myvim.sh" # TODO
    source centos_myvim.sh

    cd $CURR_PATH
  else
    printf '\n' >&2
  fi
}

function pkg_vbox() { # {{{2
  read -n1 -p "Install VirtualBox ? (y/N) " ans
  if [[ $ans =~ [Yy] ]]; then
    local pkg_version="5.2.20" # TODO 20181010
    pkg_install "dkms VirtualBox-5.2" # NOTE!
    # Install USB 2.0/3.0 Controler
    mkdir -p ${HOME}/Downloads/ && cd ${HOME}/Downloads/
    msg "Downloading VBox Extension Pack !"
    curl -fSLO "https://download.virtualbox.org/virtualbox/$pkg_version/Oracle_VM_VirtualBox_Extension_Pack-$pkg_version.vbox-extpack"
    VBoxManage extpack install "Oracle_VM_VirtualBox_Extension_Pack-$pkg_version.vbox-extpack"
    cd $CURR_PATH
  else
    printf '\n' >&2
  fi
}

function pkg_wps() { # {{{2
  read -n1 -p "Install WPS Office ? (y/N) " ans
  if [[ $ans =~ [Yy] ]]; then
    local pkg_version="10.1.0" # TODO 20181008
    local patch_version="6757" # TODO 20181008
    mkdir -p ${HOME}/Downloads/ && cd ${HOME}/Downloads/
    msg "Downloading WPS Office !"
    curl -OfSL http://kdl.cc.ksosoft.com/wps-community/download/${patch_version}/wps-office-${pkg_version}.${patch_version}-1.x86_64.rpm
    curl -OfSL http://kdl.cc.ksosoft.com/wps-community/download/fonts/wps-office-fonts-1.0-1.noarch.rpm
    sudo yum install -y wps-office-${pkg_version}.${patch_version}-1.x86_64.rpm
    sudo yum install -y wps-office-fonts-1.0-1.noarch.rpm
    cd $CURR_PATH

    # uninstall
    # sudo yum remove wps-office wps-office-fonts

    # method 1
    # 在/usr/bin/wps /usr/bin/wpp /usr/bin/et
    # gedit/usr/bin/wps
    # 在#!/bin/bash下面添加如下配置：
    # exportXMODIFIERS=”@im=ibus”
    # export QT_IM_MODULE=”ibus”

    # method 2
    # rm -rf ~/.cache ~/.ibus ~/.dbus ~/.kingsoft     and so on

  else
    printf '\n' >&2
  fi
}

function pkg_teamviewer() { # {{{2
  read -n1 -p "Install TeamViewer ? (y/N) " ans
  if [[ $ans =~ [Yy] ]]; then
    # sudo yum install -y https://download.teamviewer.com/download/linux/teamviewer-host.x86_64.rpm # teamviewer
    sudo yum install -y https://download.teamviewer.com/download/linux/teamviewer.x86_64.rpm # teamviewer
  else
    printf '\n' >&2
  fi
}

function pkg_bcompare() { # {{{2
  read -n1 -p "Install BeyondCompare ? (y/N) " ans
  if [[ $ans =~ [Yy] ]]; then
    local pkg_version="4.2.6.23150" # TODO 20181008
    mkdir -p ${HOME}/Downloads/ && cd ${HOME}/Downloads/
    msg "Downloading BeyondCompare !"
    curl -OfSL http://www.scootersoftware.com/bcompare-${pkg_version}.x86_64.rpm
    sudo rpm --import http://www.scootersoftware.com/RPM-GPG-KEY-scootersoftware
    sudo yum install -y bcompare-${pkg_version}.x86_64.rpm
    cd $CURR_PATH

    # uninstall
    # sudo yum remove bcompare
  else
    printf '\n' >&2
  fi
}

# Environment {{{1
[ -z "$REPO_PATH" ] && REPO_PATH="$HOME/repos"
[ -z "$CURR_PATH" ] && CURR_PATH=$(pwd)

# Install Packages {{{1
# -----------------------------------------------------------------
# If you are minimal CentOS, you must make internet work first.
# Command `nmcli d` to display ethernet status.
# Command `nmtui` to activate ethernet.

pkg_addition
# centos_mirror
pkg_update
sudo sed -i -e "s#GRUB_TIMEOUT=.*#GRUB_TIMEOUT=1#g" \
               /etc/default/grub # Waiting time
sudo grub2-mkconfig -o /boot/grub2/grub.cfg # out of date command : update-grub
pkg_group_basic
centos_xfce
centos_hostname

if [ $0 = "x" ]; then
  pkg_clean
  unset CURR_PATH
  exit 1
else
  # pkg_gcc
  pkg_git
  pkg_vim
  pkg_vbox
  pkg_wps
  pkg_teamviewer
  pkg_bcompare
fi
pkg_clean
unset CURR_PATH

# echo "haha" # DEBUG

# -----------------------------------------------------------------
# vim:fdm=marker
