# -----------------------------------------------------------------
# Author : Jiaobuzuji@163.com
# Reference : https://github.com/tracyone/dotfiles/
# Abstract : centos bootstrap functions
# -----------------------------------------------------------------

# function pkg_mirror()
# {
# }

function pkg_cleanall()
{
  sudo yum clean all
  sudo yum cleanup
}

function pkg_update()
{
  read -n1 -p "Update package source? (y/N) " ans
  if [[ $ans =~ [Yy] ]]; then
    pkg_cleanall
    sudo yum makecache
    sudo yum update
  fi
}

function pkg_install()
{
  for i in $1
  do
    which $i > /dev/null 2>&1
    if [ $? -ne 0 ]; then
      ret='1'
      msg "Check '$i' : Fail. Try to install it automatically!"

      sudo yum install $1 -y || error "Installation of '$i' failure, please install it manually!"
    else
      ret='0'
      success "Check '$i' : Success!"
    fi
  done
}

function tools_git()
{
  # repo_sync  "$REPO_PATH" \
  #            "https://github.com/git/git/" \
  #            "v2.16.1" \
  #            "git.git"
  # repo_sync  "$REPO_PATH" \
  #            "https://github.com/git/git/" \
  #            "master" \
  #            "git.git"

  # if [ -x "$(which git)" ];
  which git > /dev/null 2>&1
  if [ git -eq 0 ]; then
    read -n1 -p "'git' has already in system. Do you want to reinstall it ? (y/N) " ans
    [[ $ans =~ [Yy] ]] && sudo yum remove git || return 1
  fi

  mkdir -p "$HOME/git" && cd "$HOME/git"
  if [[ ! -d "$HOME/git/v2.16.1"  ]]; then
    wget -c "https://github.com/git/git/archive/v2.16.1.tar.gz" && tar -zxf "v2.16.1.tar.gz"
  fi
  cd "v2.16.1"

  pkg_install "gcc gcc-c++ expat-devel gettext-devel openssl-devel zlib-devel perl-ExtUtils-MakeMaker asciidoc xmlto texinfo docbook2X"
  ln -s /usr/bin/db2x_docbook2texi /usr/bin/docbook2x-texi
  make prefix=/usr all doc info
  if [ $? -eq 0 ]; then
    sudo make prefix=/usr install install-doc install-html install-info
  fi
}


# -----------------------------------------------------------------
# vim:fdm=marker
