# -----------------------------------------------------------------
# Author : Jiaobuzuji@163.com
# Reference : https://github.com/tracyone/dotfiles/
# Abstract : ubuntu bootstrap functions
# -----------------------------------------------------------------

# function pkg_mirror()
# {
# }

function pkg_cleanall()
{
  sudo apt-get autoremove -y
  sudo apt-get autoclean
  sudo apt-get clean
}

function pkg_update()
{
  read -n1 -p "Update package source? (y/N) " ans
  if [[ $ans =~ [Yy] ]]; then
    pkg_cleanall
    sudo apt-get update
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

      sudo apt-get install $1 --allow-unauthenticated -y || sudo apt-get install $1 --fix-missing --allow-unauthenticated -y || error "Installation of '$i' failure, please install it manually!"
    else
      ret='0'
      success "Check '$i' : Success!"
    fi
  done
}


# -----------------------------------------------------------------
# vim:fdm=marker
