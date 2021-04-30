#!/usr/bin/env bash

# -----------------------------------------------------------------
# Author : Jiaobuzuji@163.com
# Abstract : install Gitlab Community Edition
# Official : https://about.gitlab.com/install/?version=ce
# Docs : http://docs.gitlab.com/ce
# Mirrors,Tuna : https://mirror.tuna.tsinghua.edu.cn/help/gitlab-ce/
# -----------------------------------------------------------------

# install and configure the necessary dependencies
sudo apt-get install -y curl openssh-server ca-certificates tzdata perl
# install Postfix to send notification emails
sudo apt-get install -y postfix
# add GPG key
curl https://packages.gitlab.com/gpg.key 2> /dev/null | sudo apt-key add - &>/dev/null

# ubuntu 20.04 (lsb_release -c)
echo "
deb https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/ubuntu focal main
deb https://mirrors.tuna.tsinghua.edu.cn/gitlab-runner/ubuntu focal main
" > gitlab-ce.list
sudo chown root:root gitlab-ce.list
sudo mv gitlab-ce.list /etc/apt/sources.list.d/

sudo apt-get update
sudo apt-get install gitlab-ce gitlab-runner

# Next Step : restart network

