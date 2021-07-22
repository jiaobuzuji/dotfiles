#!/usr/bin/env bash

# -----------------------------------------------------------------
# Author : Jiaobuzuji@163.com
# Abstract : install Gitlab Community Edition
# Official : https://about.gitlab.com/install/?version=ce
# Docs : http://docs.gitlab.com/ce
# Mirrors,Tuna : https://mirror.tuna.tsinghua.edu.cn/help/gitlab-ce/
# -----------------------------------------------------------------

# add /etc/yum.repos.d/gitlab-ce.repo
# add /etc/yum.repos.d/gitlab-runner.repo

echo "
[gitlab-ce]
name=Gitlab CE Repository
baseurl=https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/el\$releasever/
gpgcheck=0
enabled=1

[gitlab-runner]
name=gitlab-runner
baseurl=https://mirrors.tuna.tsinghua.edu.cn/gitlab-runner/yum/el\$releasever-\$basearch/
repo_gpgcheck=0
gpgcheck=0
enabled=1
gpgkey=https://packages.gitlab.com/gpg.key
" > gitlab-all.repo

sudo chown root:root gitlab-all.repo
sudo mv -i gitlab-all.repo /etc/yum.repos.d/

sudo yum makecache
sudo yum install -y curl policycoreutils-python openssh-server openssh-clients perl
sudo systemctl enable sshd
sudo systemctl start sshd
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo systemctl reload firewalld

# external SMTP server. Email
sudo yum install postfix
sudo systemctl enable postfix
sudo systemctl start postfix

# sudo EXTERNAL_URL="http://127.0.0.1:8081" yum install gitlab-ce gitlab-runner
sudo yum install gitlab-ce gitlab-runner

sudo sed -i -e "s#^exernal_url$#exernal_url 'http://127.0.0.1:8081'#g" "/etc/gitlab/gitlab.rb"
# echo "git_data_dirs({ "default" => { "path" => "/home/gitlab/git-data" } })" >>  "/etc/gitlab/gitlab.rb"
sudo gitlab-ctl reconfigure

# Next Step : restart network
# ifconfig enp2s0 down
# ifconfig enp2s0 up

# disable Boot start.
# sudo systemctl disable gitlab-runsvdir.service

# start gitlab-ce
gitlab-ctl start
gitlab-ctl status
gitlab-ctl --help

# start gitlab-runner
systemctl start gitlab-runner
systemctl status gitlab-runner
# register
gitlab-runner register
