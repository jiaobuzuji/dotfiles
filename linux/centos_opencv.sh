#!/usr/bin/bash
echo "执行该脚本时，请确保下载完opencv-3.4.15.zip文件，该文件与脚本处于同一目录下。"
sleep 2
echo
echo

echo -e '\033[32m======= 安装系统依赖文件 ==========\033[0m'
sleep 2
echo
sudo yum -y install make cmake cmake3 zip unzip
sudo yum -y install gcc gcc-c++ kernel-devel gcc-essential gcc-gfortran
sudo yum -y install libgnomeui-devel
sudo yum -y install gtk2 gtk2-devel gtk2-devel-docs
sudo yum -y install libv4l-devel gstreamer-plugins-base-devel
sudo yum -y install autoconf automake bzip2 bzip2-devel freetype-devel 
sudo yum -y install git libtool mercurial pkgconfig zlib-devel
sudo yum -y install python-devel numpy libdc1394-devel 
sleep 2
echo



# echo -e '\033[32m======= ffmpeg组件安装 ==========\033[0m'
# sleep 2
# echo
# sudo yum -y install epel-release
# rpm –import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro 
# rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-1.el7.nux.noarch.rpm
# sudo yum -y install ffmpeg ffmpeg-devel
# ffmpeg -version
# sleep 2
# echo



echo
echo -e '\033[32m======= opencv安装 ==========\033[0m'
sleep 3
echo
echo
if [[ ! -f "$HOME/opencv-3.4.15.zip" ]]; then
  echo "文件不存在"
else
  echo "准备解压文件"
  echo
  echo
  unzip opencv-3.4.15.zip
  mv opencv-3.4.15 opencv
  cd opencv
  mkdir build && cd build
  echo "检查依赖项..."
  sleep 2
  # -D OPENCV_EXTRA_MODULES_PATH=~/opencv_build/opencv_contrib/modules # git clone https://github.com/opencv/opencv_contrib.git
  cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=${HOME}/.local \
    -D INSTALL_C_EXAMPLES=ON \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D OPENCV_GENERATE_PKGCONFIG=ON \
    -D BUILD_EXAMPLES=ON ..
  if [ $? -ne 0 ]; then
    echo "依赖项异常"
  else
    echo "准备编译..."
    sleep 2
    make -j$(nproc)
    if [ $? -ne 0 ]; then
      echo "编译异常"
    else
      echo "准备安装..."
      sleep 2
      sudo make install
      if [ $? -ne 0 ]; then
        echo "安装异常"
      else
        echo "安装 success"
      fi
    fi
  fi
fi

# echo
# echo -e '\033[32m======= opencv配置与加载动态库 配置环境变量 ==========\033[0m'
# echo

# method 0
# echo "${HOME}/.local/lib64" >> /etc/ld.so.conf.d/opencv.conf
# # sudo ln -s ${HOME}/.local/lib64/pkgconfig/opencv4.pc /usr/share/pkgconfig/ # better
# ldconfig
# echo "====查询OpenCV版本===="
# pkg-config --modversion opencv
# echo
# echo
# echo -e '\033[32m======= All done ==========\033[0m'
# echo

# method 1
# cat >> /etc/profile <<"EOF"
# export PKG_CONFIG_PATH=${HOME}/.local/lib64/pkgconfig:$PKG_CONFIG_PATH
# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${HOME}/.local/lib64
# EOF
# source /etc/profile

# method 2
# cat >> ${HOME}/.bashrc <<"EOF" # for myself
# export PKG_CONFIG_PATH=${HOME}/.local/lib64/pkgconfig:$PKG_CONFIG_PATH
# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${HOME}/.local/lib64
# EOF

