#!/usr/bin/env bash

# -----------------------------------------------------------------
# Author : Jiaobuzuji@163.com
# Reference : https://github.com/tracyone/dotfiles/
# Abstract : bootstrap functions
# -----------------------------------------------------------------

# Environment {{{1
[ -z "${REPO_PATH}" ] && REPO_PATH="${HOME}/repos"
[ -z "${CURR_PATH}" ] && CURR_PATH=$(pwd)
[ -z "${GITSRVURL}" ] && GITSRVURL="github.com" # mirror0: github.com.cnpmjs.org(not work)   mirror1: gitee.com(not work)

# Setup Functions {{{1
# -----------------------------------------------------------------
function msg() { # {{{2
    printf '%b\n' "$1" >&2
}

function success() { # {{{2
    if [ "$ret" -eq '0' ]; then
        msg "\33[32m[✔]\33[0m ${1}${2}"
    fi
}

function pkg_install() { # {{{2
  sudo dnf install -y $1
}

function rocky_mirror() { # {{{2
  read -n1 -p "yum.repos mirror ? (y/N) " ans
  if [[ $ans =~ [Yy] ]]; then
    # sudo dnf remove -y epel-release
    sudo dnf clean all
    sudo rm -rf /var/cache/dnf /var/cache/yum

    sudo sed -e 's|^mirrorlist=|#mirrorlist=|g' \
             -e 's|^#baseurl=http://dl.rockylinux.org/$contentdir|baseurl=https://mirrors.sjtug.sjtu.edu.cn/rocky|g' \
             -i.bak \
             /etc/yum.repos.d/Rocky-*.repo

    sudo dnf install -y epel-release
    sudo sed -e 's|^metalink=|#metalink=|g' \
             -e 's|^#baseurl=https://download.example/pub|baseurl=https://mirror.sjtu.edu.cn/fedora|g' \
             -i.bak \
             /etc/yum.repos.d/epel*.repo

    sudo dnf makecache
    sudo dnf -y update
    # sudo dnf -y upgrade

    sudo rm -f /tmp/yum_save_tx* # clean log
  else
    printf '\n' >&2
  fi
}

function rocky_dwm() { # {{{2
  pkg_install 'xorg-x11-proto-devel libX11-devel libXft-devel libXinerama-devel libXinerama-devel'
  pkg_install 'xsetroot' # x11 headers
  # xbacklight TODO

  # sddm lightdm gdm(gnome)
  # sudo systemctl set-default multi-user.target # command login
  sudo systemctl set-default graphical.target # ui login
  # # https://netsarang.atlassian.net/wiki/spaces/ENSUP/pages/326697004/RHEL+8.x+XDMCP+Configuration+RHEL+8.0+RHEL+8.1
  sudo dnf install -y ${REPO_PATH}/dotfiles.git/linux/lightdm-gtk-common-1.8.5-19.el7.noarch.rpm
  sudo dnf install -y ${REPO_PATH}/dotfiles.git/linux/lightdm-gtk-1.8.5-19.el7.x86_64.rpm
  pkg_install 'lightdm' # pkg_install 'gdm'
  sudo systemctl enable lightdm # sudo systemctl disable gdm
  sudo cp -i ${REPO_PATH}/dotfiles.git/suckless/linux.jpg /usr/share/backgrounds/
  sudo sed -e 's#^\#background=#background=/usr/share/backgrounds/linux.jpg' \
      -e 's#^\#theme-name=#theme-name=Adwaita-dark' \
      -e 's#^\#icon-theme-name=#icon-theme-name=Adwaita-dark' \
      -i /etc/lightdm/lightdm-gtk-greeter.conf
  sudo cp -i ${REPO_PATH}/dotfiles.git/suckless/dwm.desktop /usr/share/xsessions/

  # dwm st dmenu surf slstatus dwmstatus slock dwm-bar
  # git clone --depth 1 git://git.suckless.org/dwm "${REPO_PATH}/dwm.git"
  # git clone --depth 1 git://git.suckless.org/dmenu "${REPO_PATH}/dmenu.git"
  # git clone --depth 1 git://git.suckless.org/st "${REPO_PATH}/st.git"
  # git clone --depth 1 git://git.suckless.org/slstatus
  # git clone --depth 1 git://git.suckless.org/dwmstatus
  # git clone --depth 1 git://git.suckless.org/surf
  # cd "${REPO_PATH}/dwm.git"
  # sed -i -e 's#X11INC = .*#X11INC = /usr/include#g' \
  #        -e 's#X11LIB = .*#X11LIB = /usr/include#g' \
  #        config.mk
  # sudo make clean install

}

function rocky_xfce() { # {{{2
  # https://wiki.xfce.org/recommendedapps

  sudo dnf group install -y Xfce
  # sudo systemctl set-default multi-user.target # command login
  sudo systemctl set-default graphical.target # ui login
  # sudo systemctl isolate graphical.target # start ui now
  # startxface4 # or `init 5`

  pkg_install "xarchiver xfce4-screenshooter xfce4-screenshooter-plugin" # xfce4-about
  pkg_install "xfdashboard xfce4-mount-plugin"
  pkg_install "system-config-users system-config-language system-config-printer"
  pkg_install "xfce4-taskmanager gnome-system-monitor gnome-system-log" # monitor
  pkg_install "xfce4-battery-plugin xbacklight" # power, brightness
  pkg_install "xfce4-notifyd" # notify

  pkg_install "usermode-gtk" # users information
  # pkg_install "evince" # pdf (WPS PDF instead)
  pkg_install "ristretto" # xfce image viewer
  # pkg_install "gimp" # xfce image editor
  # pkg_install "eog" # gnome image viewer
  pkg_install "firewall-config setroubleshoot"
  pkg_install "vinagre remmina" # remote desktop viewer
  pkg_install "seahorse" # key manager
  pkg_install "gnome-disk-utility baobab" # disk modifier & analyzer (udisksctl, mkfs.ext4)
  pkg_install "gnome-calculator" # calculator
  pkg_install "cheese" # laptop camera
  pkg_install "ghostscript ImageMagick" # convert -density 300 -quality 100 xx.pdf xx.png # pdf2jpeg pdf2png

  pkg_install "xfdashboard-themes xfwm4-themes arc-theme arc-theme-plank" # themes https://www.xfce-look.org/
  # pkg_install "numix-gtk-theme numix-icon-theme"

  # xfce4-session-settings
  # Select Application Autostart
  # SSH Key Agent (GNOME Keyring:SSH agent)
  # Select Advanced
  # Check Launch GNOME services on startup

  cat << ECHO_END
  # GDM (GNOME Display Manage) autologin
  # vi /etc/gdm/custom.conf
  # [daemon]
  # AutomaticLoginEnable=True
  # AutomaticLogin=MyName  # user name

  # Diable WIFI on boot
  # nm-applet(network-manager-applet)
  # top-right corner. logo -> right click -> disable WIFI
ECHO_END

}

function rocky_hostname() { # {{{2
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

function rocky_repos() { # {{{2
  # sudo dnf install -y http://linuxdownload.adobe.com/linux/x86_64/adobe-release-x86_64-1.0-1.noarch.rpm # flash player

  # sudo dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm # epel-release TODO CentOS 7
  # sudo dnf install -y https://download1.rpmfusion.org/free/el/rpmfusion-free-release-7.noarch.rpm # vlc TODO CentOS 7

  # rpm -i http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-xxxx.rpm # Fail !!
  # rpm -Uvh http://download.fedoraproject.org/pub/epel/xxxx.rpm

  cd ${CURR_PATH}
}

function pkg_update() { # {{{2
  read -n1 -p "Update system ? (y/N) " ans
  if [[ $ans =~ [Yy] ]]; then
    sudo dnf clean all
    sudo rm -rf /var/cache/dnf /var/cache/yum
    sudo dnf makecache
    sudo dnf -y update
    # sudo dnf -y upgrade
    # yum --enablerepo=rpmforge-extras update # use rpmforge source
    sudo rm -f /tmp/yum_save_tx* # clean log
  else
    printf '\n' >&2
  fi
}

function pkg_group_basic() { # {{{2
  # sudo dnf groups list" # dnf grp list
  # sudo dnf groups install -y "Development Tools"

  # Support chinese language
  # 'locale -a' will list all langpacks
  pkg_install "langpacks-zh_CN langpacks-ja langpacks-ko"
  # sed -i -e 's#LANG=.*#LANG="zh_CN.UTF-8"#g' /etc/locale.conf # DEPRECATED TODO

  pkg_install 'ranger zsh tmux autojump'
  # pkg_install "texinfo texi2html" # zsh
  # pkg_install "libevent-devel" # tmux

  pkg_install "gcc gcc-c++ automake autoconf cmake cmake3 wget cscope clang csh ksh libgcc libcxx" # Exuberant ctags 
  pkg_install "redhat-lsb kernel-devel openssh-server net-tools network-manager-applet"
  pkg_install "firefox vnc bzip2 ntfs-3g ntfs-3g tree xclip patch bison mlocate"
  pkg_install "libcurl-devel libtool pkgconfig zlib-devel"
  pkg_install "ocl-icd opencl-headers" # opencl
  # pkg_install "glibc.i686 zlib.i686 libXext.i686 libXtst.i686" # i686 libraries (bad ELF interpreter: No such file or directory)
  pkg_install "libgnome-devel libgnomeui-devel gtk3-devel gtk2-devel" # ui dependencies
  pkg_install "libX11-devel ncurses-devel libXpm-devel libXt-devel" # vim
  pkg_install "libXScrnSaver" # verdi
  pkg_install "compat-libtiff3" # lc_shell
  # pkg_install "asciinema" # https://asciinema.org/
  # pkg_install "meld" # compare tool
  # pkg_install "i3 i3lock" # window manager
  pkg_install "samba cifs-utils"

  pkg_install "dtc iverilog verilator gtkwave" # Freedom (RSIC V) && verilog
  pkg_install "java java-devel"
  pkg_install "perl perl-devel perl-Switch"
  pkg_install "tcl-devel"
  # pkg_install "lua lua-devel luajit luajit-devel"
  # pkg_install "ruby ruby-devel"
  # pkg_install "python36 python36-devel" # python3-pip" # TODO CentOS 7
  # sudo ln -sf /usr/bin/python3.6 /usr/bin/python3 # TODO CentOS 7

  pkg_install "fontconfig mkfontscale mkfontdir" # font tools
  # pkg_install "cjkuni-ukai-fonts " # fonts and font tools

  # command is not "7zip" or "p7zip", but "7za"!!
  pkg_install "zip p7zip p7zip-doc p7zip-gui p7zip-plugins unar" # archive tools

  pkg_install "im-chooser imsettings-gsettings" # imsettings-xim" # input method setting

  # pkg_install "gtk2-immodules gtk3-immodules gtk2-immodule-xim gtk3-immodule-xim" # input method
  pkg_install "ibus-libpinyin ibus-table-chinese-wubi-jidian"
  # pkg_install "ibus ibus-qt ibus-gtk2 ibus-gtk3 ibus-table-chinese-wubi-jidian" # ibus
  # ibus-setup # config ibus
  # imsettings-switch ibus
  # im-chooser

  # pkg_install "fcitx fcitx-configtool fcitx-table-chinese" # fcitx
  # pkg_install "fcitx fcitx-qt4 fcitx-qt5 fcitx-configtool fcitx-table-chinese" # fcitx
  # imsettings-switch fcitx # current user
  # im-chooser

  pkg_install "dia" # alternative visio
  # pkg_install "flash-plugin"
  pkg_install "vlc ffmpeg ffmpeg-devel ffmpeg-libs x264 x265"

}

function pkg_clean() { # {{{2
  read -n1 -p "Clean old kernel ? (y/N) " ans
  if [[ $ans =~ [Yy] ]]; then
    local old_kernels=$(rpm -q kernel kernel-devel kernel-headers | egrep -v $(uname -r))
    [ ! -z "$old_kernels" ] && sudo dnf remove -y $old_kernels
  else
    printf '\n' >&2
  fi
}

function pkg_gcc() { # {{{2
  # # method 0
  # read -n1 -p "Build gcc ? (y/N) " ans
  # if [[ $ans =~ [Yy] ]]; then
  #   local pkg_version="5.5.0"
  #   mkdir -p "${REPO_PATH}/gcc" && cd "${REPO_PATH}/gcc"
  #   msg "Downloading gcc source!"
  #   curl -OfSL "http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/gcc-${pkg_version}/gcc-${pkg_version}.tar.xz"
  #   tar -Jxf "gcc-${pkg_version}.tar.xz"
  #   cd "gcc-${pkg_version}"

  #   pkg_install "libmpc-devel mpfr-devel gmp-devel zlib-devel"
  #   pkg_install "texinfo flex"

  #   ./contrib/download_prerequisites
  #   sudo ldconfig

  #   mkdir -p "${HOME}/.opt/gnu"
  #   mkdir -p ../gcc-build-${pkg_version} && cd ../gcc-build-${pkg_version}

  #   sudo make uninstall # uninstall
  #   sudo make clean distclean

  #   ../gcc-${pkg_version}/configure --prefix=${HOME}/.opt/gnu/gcc-${pkg_version} --with-system-zlib --disable-multilib --enable-languages=c,c++,java
  #   if [ $? -eq 0 ]; then
  #     make -j4
  #     make install
  #   fi
  #   cd ${CURR_PATH}
  # else
  #   printf '\n' >&2
  # fi

  # method 1
  # sudo dnf install -y centos-release-scl devtoolset-8 # error
  sudo dnf install -y centos-release-scl
  sudo dnf install -y devtoolset-8
  source /opt/rh/devtoolset-8/enable # temporary
}

function pkg_git() { # {{{2
  read -n1 -p "Build git ? (y/N) " ans
  if [[ $ans =~ [Yy] ]]; then
    local pkg_version="2.19.1" # TODO 20181008
    mkdir -p "${REPO_PATH}/git" && cd "${REPO_PATH}/git"
    if [[ ! -d "${REPO_PATH}/git/git-${pkg_version}"  ]]; then
      msg "Downloading git source!"
      curl -OfSL "https://${GITSRVURL}/git/git/archive/v${pkg_version}.tar.gz" && tar -zxf "v${pkg_version}.tar.gz"
    fi
    cd "git-${pkg_version}"

    pkg_install "gcc gcc-c++ automake autoconf libcurl-devel expat-devel openssl-devel zlib-devel perl-ExtUtils-MakeMaker asciidoc xmlto texinfo docbook2X"
    sudo ln -sf /usr/bin/db2x_docbook2texi /usr/bin/docbook2x-texi
    sudo make uninstall # uninstall
    sudo make clean distclean
    make prefix=/usr all doc info
    if [ $? -eq 0 ]; then
      # if [ -x "$(which git)" ];
      which git > /dev/null 2>&1
      if [ $? -eq 0 ]; then
        read -n1 -p "'git' has already in system. Do you want to reinstall it ? (y/N) " ans
        [[ $ans =~ [Yy] ]] && sudo dnf remove git -y || return 1
      fi
      sudo make prefix=/usr install install-doc install-html install-info
    fi
    cd ${CURR_PATH}
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
      [[ $ans =~ [Yy] ]] && sudo dnf remove -y vim gvim vim-runtime vim-common vim-enhanced || return 1
    fi

    if [ ! -e "${REPO_PATH}/vim.git" ]; then
        git clone --depth 1 "https://${GITSRVURL}/vim/vim" "${REPO_PATH}/vim.git" && \
        cd "${REPO_PATH}/vim.git"
    else
        cd "${REPO_PATH}/vim.git" && git pull
    fi

    sudo dnf install -y \
        ruby ruby-devel lua lua-devel luajit luajit-devel \
        python python-devel python3 python3-devel python36 python36-devel \
        perl perl-devel perl-ExtUtils-ParseXS \
        perl-ExtUtils-XSpp perl-ExtUtils-CBuilder \
        perl-ExtUtils-Embed perl-YAML \
        tcl tcl-devel \
        libgnome-devel libgnomeui-devel gtk2-devel atk-devel libbonoboui-devel cairo-devel \
        libX11-devel ncurses-devel libXpm-devel libXt-devel libcxx \
        libsodium libsodium-devel \
        gcc cscope git
    curl -OfsSL "https://raw.githubusercontent.com/jiaobuzuji/vimrc/master/tools/build_vim.sh"
    source build_vim.sh

    cd ${CURR_PATH}
  else
    printf '\n' >&2
  fi
}

function pkg_vlc() { # {{{2
  # https://wiki.videolan.org/UnixCompile/
  # https://trac.ffmpeg.org/wiki/CompilationGuide

  read -n1 -p "Build vlc ? (y/N) " ans
  if [[ $ans =~ [Yy] ]]; then
    local pkg_version="3.0.4" # TODO 20181010
    local gcc_version="5.5.0"

    if [ ! -e "${REPO_PATH}/ffmpeg.git" ]; then
      git clone --depth 1 "git://source.ffmpeg.org/ffmpeg" "${REPO_PATH}/ffmpeg.git" && \
      cd "${REPO_PATH}/ffmpeg.git"
    else
      cd "${REPO_PATH}/ffmpeg.git" && git pull
    fi
    pkg_install "nasm yasm freetype freetype-devel"
    # TODO


    mkdir -p "${REPO_PATH}/vlc" && cd "${REPO_PATH}/vlc"
    msg "Downloading vlc source!"
    curl -OfSL "ftp://ftp.videolan.org/pub/vlc/${pkg_version}/vlc-${pkg_version}.tar.xz" && tar -Jxf "vlc-${pkg_version}.tar.xz"
    cd "vlc-${pkg_version}"

    sudo make uninstall # uninstall
    sudo make clean distclean

    # Get the third-party libraries
    # https://wiki.videolan.org/Contrib_Status/
    pkg_install "lua lua-devel gstreamer gstreamer-devel x265 x265-devel " # ffmpeg ffmpeg-devel ffmpeg-libs
    pkg_install "a52dec a52dec-devel caca-utils dirac dirac-devel expat expat-devel faac faac-devel faad2 faad2-devel \
      flac flac-devel fribidi-devel gettext gnutls gnutls-devel gnutls-utils lame lame-devel live555 live555-devel \
      libass libass-devel libcaca libcaca-devel libcddb libcddb-devel libcdio libcdio-devel libdap libdap-devel libdca-devel \
      libdvbpsi libdvbpsi-devel libdvdnav libdvdnav-devel libdvdread libebml libebml-devel freetype freetype-devel fribidi \
      libgcrypt libgcrypt-devel libgpg-error libgpg-error-devel libjpeg-turbo libmad libmad-devel libmatroska libmatroska-devel \
      libmodplug libmodplug-devel libmpcdec-devel libmpeg2-devel libogg-devel liboil-devel libpng libpng-devel libshout \
      libshout-devel libtheora-devel libtiff libupnp libupnp-devel libvorbis-devel libX11 libX11-devel libxcb libxcb-devel \
      libxml2 libxml2-devel mpeg2dec portaudio-devel qt4 qt4-devel schroedinger-devel SDL-devel SDL_image SDL_image-devel speex \
      speex-devel taglib-devel twolame twolame-devel vcdimager vcdimager-devel vcdimager-libs x264 x264-devel yasm zlib \
      lua xcb-util-devel libsamplerate-devel"
    # # another method
    # cd contrib
    # mkdir native && cd native
    # sudo make clean distclean
    # ../bootstrap
    # make
    # cd ../../

    # https://wiki.videolan.org/Configure/
    ./bootstrap
    CC="${HOME}/.opt/gnu/gcc-${gcc_version}/bin/gcc" \
    CXX="${HOME}/.opt/gnu/gcc-${gcc_version}/bin/g++" \
    ./configure --prefix=/usr --enable-run-as-root \
      --enable-x11 --enable-xvideo --disable-gtk \
      --enable-sdl --enable-ffmpeg --with-ffmpeg-mp3lame \
      --enable-mad --enable-libdvbpsi --enable-a52 --enable-dts \
      --enable-libmpeg2 --enable-dvdnav --enable-faad \
      --enable-vorbis --enable-ogg --enable-theora --enable-faac\
      --enable-mkv --enable-freetype --enable-fribidi \
      --enable-speex --enable-flac --enable-livedotcom \
      --with-livedotcom-tree=/usr/lib/live --enable-caca \
      --enable-skins --enable-alsa --disable-kde\
      --disable-qt --enable-wxwindows --enable-ncurses \
      --enable-release \
      --enable-skins2
      # --disable-avcodec

    if [ $? -eq 0 ]; then
      make -j4
      sudo make install
    fi
    cd ${CURR_PATH}
  else
    printf '\n' >&2
  fi
}

function pkg_vbox() { # {{{2
  read -n1 -p "Install VirtualBox ? (y/N) " ans
  if [[ $ans =~ [Yy] ]]; then
    local vbox_version = "6.1.32"
    local rpm_vbox="VirtualBox-6.1-6.1.32_149290_el8-1.x86_64.rpm"
    local rpm_extpack="Oracle_VM_VirtualBox_Extension_Pack-$vbox_version.vbox-extpack"

    # Install VirtualBox
    # method 0
    # cd /etc/yum.repos.d/
    # msg "Getting virtualbox repo !"
    # sudo curl -OfSL http://download.virtualbox.org/virtualbox/rpm/rhel/virtualbox.repo # vbox
    # pkg_install virtualbox
    # method 1
    cd ${HOME}/Downloads/
    msg "Downloading VBox RPM!"
    sudo curl -OfSL "https://mirrors.tuna.tsinghua.edu.cn/virtualbox/rpm/el8/$rpm_vbox"
    sudo dnf install -y $rpm_vbox

    # mount virtualbox guest additions
    # sudo mount -t iso9660 /dev/cdrom /mnt/cdrom # or sudo mount /dev/cdrom /mnt/cdrom

    # Install USB 2.0/3.0 Controler
    cd ${HOME}/Downloads/
    msg "Downloading VBox Extension Pack !"
    # curl -fSLO "https://download.virtualbox.org/virtualbox/$vbox_version/Oracle_VM_VirtualBox_Extension_Pack-$vbox_version.vbox-extpack"
    curl -fSLO "https://mirrors.tuna.tsinghua.edu.cn/virtualbox/$vbox_version/$rpm_extpack"
    sudo VBoxManage extpack install --replace "$rpm_extpack"
    # method 0
    sudo usermod -a -G vboxusrs $(whoami) && reboot
    # cat /etc/group | grep vboxusrs
    # method 1
    #vim /etc/group
    #append your user name to vboxusrs

    cd ${CURR_PATH}
  else
    printf '\n' >&2
  fi
}

function pkg_wps() { # {{{2
  read -n1 -p "Install WPS Office ? (y/N) " ans
  if [[ $ans =~ [Yy] ]]; then
    cd ${HOME}/Downloads/
    msg "Download and Install WPS Office !"

    # local pkg_version="10.1.0" # TODO 20181008
    # local patch_version="6757" # TODO 20181008
    # curl -OfSL http://kdl.cc.ksosoft.com/wps-community/download/${patch_version}/wps-office-${pkg_version}.${patch_version}-1.x86_64.rpm
    # curl -OfSL http://kdl.cc.ksosoft.com/wps-community/download/fonts/wps-office-fonts-1.0-1.noarch.rpm
    # sudo dnf install -y wps-office-${pkg_version}.${patch_version}-1.x86_64.rpm
    # sudo dnf install -y wps-office-fonts-1.0-1.noarch.rpm

    curl -OfSL "https://wdl1.cache.wps.cn/wps/download/ep/Linux2019/10161/wps-office-11.1.0.10161-1.x86_64.rpm"
    sudo dnf install -y wps-office-11.1.0.10161-1.x86_64.rpm
    cd ${CURR_PATH}
    # View -> Eye Protection Mode

    # uninstall
    # sudo dnf remove wps-office wps-office-fonts

    # method 1
    # 在/usr/bin/wps /usr/bin/wpp /usr/bin/et
    # gedit/usr/bin/wps
    # 在#!/bin/bash下面添加如下配置：
    # export XMODIFIERS=”@im=ibus”
    # export GTK_IM_MODULE="ibus"
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
    # sudo dnf install -y https://download.teamviewer.com/download/linux/teamviewer-host.x86_64.rpm # teamviewer
    sudo dnf install -y https://download.teamviewer.com/download/linux/teamviewer.x86_64.rpm # teamviewer
    sudo systemctl disable teamviewerd
  else
    printf '\n' >&2
  fi
}

function pkg_bcompare() { # {{{2
  read -n1 -p "Install BeyondCompare ? (y/N) " ans
  if [[ $ans =~ [Yy] ]]; then
    local pkg_version="4.2.6.23150" # TODO 20181008
    cd ${HOME}/Downloads/
    msg "Downloading BeyondCompare !"
    curl -OfSL http://www.scootersoftware.com/bcompare-${pkg_version}.x86_64.rpm
    sudo rpm --import http://www.scootersoftware.com/RPM-GPG-KEY-scootersoftware
    pkg_install "poppler-utils" # pdftotext, for BeyondCompare !!
    sudo dnf install -y bcompare-${pkg_version}.x86_64.rpm
    sudo rpm -ivh bcompare-${pkg_version}.x86_64.rpm

    # crack
    # sudo mv /etc/yum.repos.d/scootersoftware.repo /etc/yum.repos.d/scootersoftware.repo.backup
    cd /usr/lib64/beyondcompare
    sudo cp BCompare BCompare.bak
    sudo sed -i "s/keexjEP3t4Mue23hrnuPtY4TdcsqNiJL-5174TsUdLmJSIXKfG2NGPwBL6vnRPddT7tH29qpkneX63DO9ECSPE9rzY1zhThHERg8lHM9IBFT+rVuiY823aQJuqzxCKIE1bcDqM4wgW01FH6oCBP1G4ub01xmb4BGSUG6ZrjxWHJyNLyIlGvOhoY2HAYzEtzYGwxFZn2JZ66o4RONkXjX0DF9EzsdUef3UAS+JQ+fCYReLawdjEe6tXCv88GKaaPKWxCeaUL9PejICQgRQOLGOZtZQkLgAelrOtehxz5ANOOqCaJgy2mJLQVLM5SJ9Dli909c5ybvEhVmIC0dc9dWH+/N9KmiLVlKMU7RJqnE+WXEEPI1SgglmfmLc1yVH7dqBb9ehOoKG9UE+HAE1YvH1XX2XVGeEqYUY-Tsk7YBTz0WpSpoYyPgx6Iki5KLtQ5G-aKP9eysnkuOAkrvHU8bLbGtZteGwJarev03PhfCioJL4OSqsmQGEvDbHFEbNl1qJtdwEriR+VNZts9vNNLk7UGfeNwIiqpxjk4Mn09nmSd8FhM4ifvcaIbNCRoMPGl6KU12iseSe+w+1kFsLhX+OhQM8WXcWV10cGqBzQE9OqOLUcg9n0krrR3KrohstS9smTwEx9olyLYppvC0p5i7dAx2deWvM1ZxKNs0BvcXGukR+/g" BCompare
    # bcompare
    # license:xxxxx
    # sudo chmod 444 BC4Key.txt BCState.xml BCLOCK_0.0 BCState.xml.bak
    # sudo cp ~/.config/bcompare/BC4Key.txt /etc/  # for all users

    cd ${CURR_PATH}

    # uninstall
    # sudo dnf remove bcompare

    # svn/git merge
    # bcompare mine.file theirs.file base.file merged.file
  else
    printf '\n' >&2
  fi
}

function pkg_iptux() { # {{{2
  read -n1 -p "Install iptux ? (y/N) " ans
  if [[ $ans =~ [Yy] ]]; then
    pkg_install "gtk2-devel glib2-devel GConf2-devel gstreamer1-devel gcc gcc-c++ make cmake3"
    # sudo ln -s /usr/bin/cmake3 /usr/bin/cmake

    git clone --depth 1 "https://${GITSRVURL}/open-source-parsers/jsoncpp" "${REPO_PATH}/jsoncpp.git" && \
      cd "${REPO_PATH}/jsoncpp.git"
    mkdir -p build/release
    cd build/release
    cmake3 -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=release -DBUILD_STATIC_LIBS=OFF -DBUILD_SHARED_LIBS=ON -DARCHIVE_INSTALL_DIR=. -DCMAKE_INSTALL_INCLUDEDIR=include -G "Unix Makefiles" ../..
    make && sudo make install

    git clone "https://${GITSRVURL}/iptux-src/iptux" "${REPO_PATH}/iptux.git" && \ # Official
      cd "${REPO_PATH}/iptux.git"
    git checkout "v0.7.5" # TODO 20181008
    mkdir build && cd build && cmake3 ..
    make && sudo make install

    # firewall
    sudo firewall-cmd --permanent --zone=public --add-port=2425/tcp
    sudo firewall-cmd --permanent --zone=public --add-port=2425/udp
    sudo firewall-cmd --complete-reload
    cd ${CURR_PATH}
  else
    printf '\n' >&2
  fi
}

function pkg_nodejs() { # {{{2
  sudo dnf install nodejs
  sudo npm install -g n
  sudo n lts
  # use "n" commend to select node version
}

function pkg_cmake() { # {{{2
  # # method 0
  # git clone --depth 1 -b release "https://${GITSRVURL}/Kitware/CMake" "${REPO_PATH}/CMake.git"
  # cd "${REPO_PATH}/CMake.git"
  # ./bootstrap
  # gmake
  # sudo gmake install
  # cd ${CURR_PATH}

  # method 1
  sudo ln -s /usr/bin/cmake3 /usr/bin/cmake
}

function pkg_glibc() { # {{{2
  cd "${REPO_PATH}/gnu"
  wget http://ftp.gnu.org/gnu/glibc/glibc-2.19.tar.xz # 2.19 for clangd
  tar xvf glibc-2.19.tar.xz
  cd glibc-2.19
  mkdir build
  cd build
  ../configure --prefix=${HOME}/.opt/gnu/glibc-2.19
  make -j$(nproc)
  make install
  export LD_LIBRARY_PATH=/opt/glibc-2.19/lib
  cd ${CURR_PATH}
}

function pkg_llvm() { # {{{2
  git clone --depth 1 "https://gitee.com/mirrors/llvm-project" "${REPO_PATH}/gnu/llvm-project"
  cd "$REPO_PATH/gnu/llvm-project"
  mkdir build
  cd build
  # cmake3 -j$(nproc) -DCMAKE_BUILD_TYPE=Release -G "Unix Makefiles" ../llvm   # NOTE!! all project
  # clangd project
  cmake3 -j$(nproc) -DCMAKE_INSTALL_PREFIX=/opt/llvm -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra" -DCMAKE_BUILD_TYPE=Release -G "Unix Makefiles" ../llvm

  make -j$(nproc)
  sudo make install
}

function pkg_nvim() { # {{{2
  curl -OfSL https://github.com.cnpmjs.org/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz
  curl -OfSL https://github.com.cnpmjs.org/neovim/neovim/releases/download/nightly/nvim-win64.zip
}

# Install Packages {{{1
# -----------------------------------------------------------------
# If you are minimal CentOS, you must make internet work first.
# Command `nmcli d` to display ethernet status.
# Command `nmtui` to activate ethernet.

rocky_repos
rocky_mirror
# pkg_update

sudo sed -i -e "s#GRUB_TIMEOUT=.*#GRUB_TIMEOUT=1#g" \
               /etc/default/grub # Waiting time
sudo grub2-mkconfig -o /boot/grub2/grub.cfg # out of date command : update-grub

pkg_group_basic
rocky_dwm
rocky_xfce
rocky_hostname

sudo xbacklight -set 8 # for laptop
sudo sed -i -e "s#ONBOOT=.*#ONBOOT=yes#g" \
                /etc/sysconfig/network-scripts/ifcfg-e* # Activate ethernet while booting

mkdir -p "${HOME}/Downloads/"
# download rpm and dependencies!!
# yumdownloader meld --resolve --destdir =/home

if [ $0 = "x" ]; then
  # pkg_clean
  exit 1
else
  # pkg_gcc
  # pkg_git
  pkg_vim
  # pkg_vlc
  pkg_vbox
  pkg_wps
  # pkg_teamviewer
  pkg_bcompare
  pkg_iptux
  pkg_nodejs
  # pkg_cmake
  # pkg_glibc
  # pkg_llvm
  # pkg_nvim
fi
# pkg_clean

# -----------------------------------------------------------------
# vim:fdm=marker
