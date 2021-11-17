#! /usr/bin/env bash

# -----------------------------------------------------------------
# Author : Jiaobuzuji@163.com
# Reference : https://github.com/tracyone/dotfiles/
# Reference : https://github.com/spf13/spf13-vim/blob/3.0/bootstrap.sh
# Abstract : bootstrap
# -----------------------------------------------------------------


# BASIC SETUP TOOLS (functions) {{{1
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
        ln -sfT "$1" "$2"
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



# SETUP FUNCTIONS {{{1
# -----------------------------------------------------------------
# repo_sync (repo_path, repo_uri, repo_branch, repo_name)
function repo_sync() {
  local repo_path="$1"
  local repo_uri="$2"
  local repo_branch="$3"
  local repo_name="$4"

  msg "Trying to clone or update '$repo_name' repository."

  if [ ! -e "$repo_path/$repo_name" ]; then
    git clone --depth 1 -b "$repo_branch" "$repo_uri" "$repo_path/$repo_name"
    # git clone "$repo_uri" "$repo_path/$repo_name"
    ret="$?"
    success "Successfully cloned '$repo_name'."
  else
    cd "$repo_path/$repo_name" && git pull origin "$repo_branch"
    ret="$?"
    success "Successfully updated '$repo_name'"
  fi
  msg ""
  cd ${CURR_PATH}
  debug
}

function gen_ssh_key() {
  read -n1 -p "Generating a new SSH key? (y/N) " ans
  if [[ $ans =~ [Yy] ]]; then
    msg "Generating a new SSH key."
    ssh-keygen -t rsa -b 4096 -C "jiaobuzuji@163.com"

    # sudo sed -i -e "s/^\s*#\?\s*Port\s.*/Port 22/g" "/etc/ssh/sshd_config" #Port 22
    sudo sed -i -e "s/^\s*#\?\s*PermitRootLogin\s.*/PermitRootLogin no/g" "/etc/ssh/sshd_config" # Prohibit root login by ssh

    # sudo systemctl restart sshd # service sshd restart
    sudo systemctl disable sshd

    # -----------------------------------------------
    # Microsoft Windows. put the following in .bashrc
    # env=~/.ssh/agent.env
    # agent_load_env () { test -f "$env" && . "$env" >| /dev/null ; }

    # agent_start () {
    #     (umask 077; ssh-agent >| "$env")
    #     . "$env" >| /dev/null ; }

    # agent_load_env

    # # agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2= agent not running
    # agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

    # if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
    #     agent_start
    #     ssh-add ~/.ssh/github_rsa
    # elif [ "$SSH_AUTH_SOCK" ] && [ $agent_run_state = 1 ]; then
    #     ssh-add ~/.ssh/github_rsa
    # fi

    # unset env
    # -----------------------------------------------

    # msg "Adding it to the ssh-agent."
    # eval "$(ssh-agent -s)"
    # ssh-add ~/.ssh/id_rsa
    # xclip -sel clip < ~/.ssh/id_rsa.pub # Copies the contents of the id_rsa.pub file to your clipboard
  else
    printf '\n' >&2
  fi
}

function my_copyright() {
  unset CURR_PATH
  msg "\nThanks for installing ."
  msg "Copyright © `date +%Y`  http://www.jiaobuzuji.com/"
}


# MAIN() {{{1
# -----------------------------------------------------------------
# Environment {{{2
function main_func() {

msg "\nOS Kernel   : `uname`"
msg   "Distributor : $(head -n1 /etc/issue | cut -f1 -d\ )" # Ubuntu, CentOS6(but not CenOS7), Debian
# msg "`lsb_release -d`\n" # "lsb_release" is not bare command.
# msg $(lsb_release -si) # $(lsb_release -i | cut -f2)

[ -z "${REPO_PATH}" ] && REPO_PATH="${HOME}/repos"
[ -z "${CURR_PATH}" ] && CURR_PATH=$(pwd)
[ -z "${GITSRVURL}" ] && GITSRVURL="github.com" # mirror0: github.com.cnpmjs.org   mirror1: gitee.com(not work)

# Install basic packages {{{2
if [ -e "/etc/centos-release" ]; then # CentOS
  pkg_check "yum curl"

  if [ $0 = "./install.sh" ]; then
    echo "Local install"
    bash "${CURR_PATH}/linux/centos_setup.sh" # debug or local install
  else
    echo "URL install"
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/jiaobuzuji/dotfiles/master/linux/centos_setup.sh)" $0
  fi

else # Ubuntu
  pkg_check "apt-get curl"
  # [ ! -f "${HOME}/.myshell/extra.sh" ] && echo -ne "alias which='which -a'" > "${HOME}/.myshell/extra.sh"
fi

if [ $0 = "./install.sh" ]; then
  source "${CURR_PATH}/linux/tools_func.sh"
elif [ $0 = "x" ]; then
  my_copyright
  exit 1
else
  repo_sync  "${REPO_PATH}" \
             "https://${GITSRVURL}/jiaobuzuji/dotfiles" \
             "master" \
             "dotfiles.git"
  source "${REPO_PATH}/dotfiles.git/linux/tools_func.sh"
fi

gen_ssh_key
msg ""
# exit 1 # DEBUG


# Awesome tools {{{2
# tools_ranger # TODO
tools_autojump
tools_zsh
tools_tmux
tools_rg_ag_fd
tools_fonts
if [ -e "/etc/centos-release" ]; then # CentOS
  tools_rar
fi
# exit 1 # DEBUG


# Create Links {{{2
mkdir -p ${HOME}/{.ssh,.vnc}
lnif "${REPO_PATH}/dotfiles.git/xfce.config"   "${HOME}/.config"
lnif "${REPO_PATH}/dotfiles.git/shell/.zshrc"   "${HOME}/.zshrc"
lnif "${REPO_PATH}/dotfiles.git/shell/.bashrc"   "${HOME}/.bashrc"
lnif "${REPO_PATH}/dotfiles.git/git/.gitconfig"   "${HOME}/.gitconfig"
lnif "${REPO_PATH}/dotfiles.git/tmux/.tmux.conf"   "${HOME}/.tmux.conf"
# lnif "${REPO_PATH}/dotfiles.git/ssh/config"   "${HOME}/.ssh/config"


# Setup EDA tools {{{2
# bash "${REPO_PATH}/dotfiles.git/eda/eda_setup.sh"


# Finish {{{2
my_copyright
}


# Run Main {{{2
main_func | tee install.log

# -----------------------------------------------------------------
# vim:fdm=marker
