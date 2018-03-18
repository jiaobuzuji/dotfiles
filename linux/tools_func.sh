# -----------------------------------------------------------------
# Author : Jiaobuzuji@163.com
# Reference : https://github.com/tracyone/dotfiles/
# Abstract : tools functions
# -----------------------------------------------------------------

function tools_autojump()
{
  # pkg_install "autojump autojump-zsh" # CentOS
  # pkg_install "autojump" # Ubuntu

  repo_sync  "$REPO_PATH" \
    "https://github.com/wting/autojump" \
    "master" \
    "autojump.git"

  # ./install.py  # for current user
  cd "$REPO_PATH/autojump.git" && sudo ./install.py -s # for all users
}


function tools_zsh()
{
  # pkg_install "zsh zsh-doc" # zsh
  pkg_install "texinfo texi2html yodl perl" # zsh-doc dependencies

  repo_sync  "$REPO_PATH" \
             "https://github.com/zsh-users/zsh/" \
             "master" \
             "zsh.git"
  cd "$REPO_PATH/zsh.git"
  git checkout $(git describe --tags `git rev-list --tags --max-count=1`)
  ./Util/preconfig
  ./configure --prefix=/usr

  if [ $? -eq 0 ]; then
    make
    # sudo checkinstall # package for Debain linux
    sudo make install
  fi

  if [ -n "$ZSH_VERSION" ]; then
    [ -x $(grep '/usr/bin/zsh' '/etc/shells') ] || sudo sed -i '$a\/usr/bin/zsh' '/etc/shells'
    chsh -s /usr/bin/zsh
    # chsh -s $(which zsh) or chsh -s `which zsh` or chsh -s /bin/zsh, and restart shell
  fi

  repo_sync  "$REPO_PATH" \
    "https://github.com/robbyrussell/oh-my-zsh" \
    "master" \
    "oh-my-zsh.git"
  # cd oh-my-zsh/tools && ./install.sh || ( echo "Error occurred!exit.";exit 3 )
  # curl -L git.io/antigen > antigen.zsh
}

function tools_tmux()
{
  # pkg_install "tmux"
  if [ $linux_distributor == "Ubuntu" ]; then
    pkg_install "libevent-dev libcurses-ocaml-dev"
  else
    pkg_install "libevent2-devel" # TODO
  fi
  pkg_install "xclip"

  repo_sync  "$REPO_PATH" \
    "https://github.com/tmux/tmux" \
    "master" \
    "tmux.git"
  cd "$REPO_PATH/tmux.git"
  git checkout $(git describe --tags `git rev-list --tags --max-count=1`)

  ./autogen.sh
  ./configure --prefix=/usr

  if [ $? -eq 0 ]; then
    make
    # sudo checkinstall # package for Debain linux
    sudo make install
  fi
}

# function tools_vim()
# {
# }


# -----------------------------------------------------------------
# vim:fdm=marker
