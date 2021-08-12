#! /usr/bin/env bash

# -----------------------------------------------------------------
# Author : Jiaobuzuji@163.com
# Reference : https://wiki.videolan.org/Win32Compile/
# Reference : https://wiki.videolan.org/VLC_configure_help
# Reference : https://trac.videolan.org/vlc/ticket/18609
# Reference : https://wiki.videolan.org/Contrib_Status
# Reference : ftp://ftp.videolan.org/pub/videolan
# Reference : https://packages.ubuntu.com/
# Reference : https://higoge.github.io/2015/07/17/sm02/
# OS : Ubuntu 18.04 LTS
# VLC : 2.2.8
# HOST_TRIPLET : i686-w64-mingw32
# -----------------------------------------------------------------

# -----------------------------------------------------------------
# Set Environment {{{1
source "../linux/basic_func.sh"
# source "ubuntu_func.sh"
# pkg_update
# sudo apt-get -y build-dep vlc
# pkg_install "gcc-mingw-w64-x86-64 g++-mingw-w64-x86-64 mingw-w64-tools" # NB: you need mingw-w64 version 5.0.1 to compile it.
# pkg_install "lua5.2 liblua5.2-dev libtool automake autoconf autopoint make gettext pkg-config"
# pkg_install "qt4-dev-tools qt4-default git subversion cmake cvs"
# pkg_install "wine64-development-tools libwine-dev zip p7zip nsis bzip2"
# pkg_install "yasm ragel ant openjdk-8-jdk default-jdk protobuf-compiler dos2unix"
# pkg_install "gperf flex bison liborc-0.4-dev"
# sudo ldconfig

# sudo update-alternatives --config java
# * 0 : /usr/lib/jvm/java-11-openjdk-amd64/bin/java
#   1 : /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java

# sudo update-alternatives --config javac

# if you are not 'schroedinger', download schroedinger_1.0.11.orig.tar.gz (https://packages.ubuntu.com/xenial/libschroedinger-dev)
# tar -zxf schroedinger_1.0.11.orig.tar.gz
# cd schroedinger_1.0.11
# ./configure --prefix=/usr
# make
# sudo make install
# cd ..

# curl -R -O ftp://ftp.videolan.org/pub/vlc/2.2.8/vlc-2.2.8.tar.xz
# curl -R -O ftp://ftp.videolan.org/pub/videolan/contrib/i686-w64-mingw32/vlc-contrib-i686-w64-mingw32-20160218.tar.bz2
# tar -Jxf vlc-2.2.8.tar.xz
# mv vlc-2.2.8 vlc

# sudo sh vlc.sh
msg ""

# Prepare 3rd party libraries {{{1
HOST_TRIPLET="i686-w64-mingw32"
cd vlc

# mkdir -p contrib/win32 && cd contrib/win32
# cp -f ~/proj/vlc/vlc-contrib-i686-w64-mingw32-20160218.tar.bz2 vlc-contrib-i686-w64-mingw32-latest.tar.bz2
# make uninstall
# make clean
# make distclean
# ../bootstrap --host=${HOST_TRIPLET}
# make prebuilt
# #   make fetch
# #   make
# rm -f ../i686-w64-mingw32/bin/moc ../i686-w64-mingw32/bin/uic ../i686-w64-mingw32/bin/rcc
# # ln -sf ${HOST_TRIPLET} ../i686-w64-mingw32
# cd -

# Configure & Build & Package {{{1
# ./bootstrap
mkdir -p win32 && cd win32
# make uninstall
# make clean
# make distclean

# https://trac.videolan.org/vlc/ticket/18609
# sudo apt-get remove -y libvdpau-dev # IMHO x11/VDPAU shouldn't be checked to begin with when compiling for win32/win64 

# PKG_CONFIG_PATH=/usr/share/pkgconfig \
# PKG_CONFIG_LIBDIR=$PKG_CONFIG_LIBDIR:$HOME/tmp/vlc/vlc/contrib/${HOST_TRIPLET}/lib/pkgconfig:/usr/lib/pkgconfig:/usr/lib/x86_64-linux-gnu/pkgconfig \
# ../extras/package/win32/configure.sh --host=${HOST_TRIPLET} --build=x86_64-pc-linux-gnu --disable-goom --disable-update-check \

# PKG_CONFIG_LIBDIR=$HOME/tmp/vlc/vlc/contrib/${HOST_TRIPLET}/lib/pkgconfig \
# ../extras/package/win32/configure.sh --host=${HOST_TRIPLET} --build=x86_64-pc-linux-gnu \
# --disable-mkv \

if [ $? -eq 0 ]; then
  # make
  make package-win-common
fi

# Finish {{{1
# sudo apt-get install -y libvdpau-dev # reinstall
msg "Copyright © `date +%Y`  http://www.jiaobuzuji.com/"

# -----------------------------------------------------------------
# vim:fdm=marker
