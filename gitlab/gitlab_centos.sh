#!/usr/bin/env bash

# -----------------------------------------------------------------
# Author : Jiaobuzuji@163.com
# Abstract : install Gitlab Community Edition
# Official Docs : https://about.gitlab.com/install/#centos-7
# Tuna : https://mirror.tuna.tsinghua.edu.cn/help/gitlab-ce/
# -----------------------------------------------------------------

# add /etc/yum.repos.d/gitlab-ce.repo

echo "
[gitlab-ce]
name=Gitlab CE Repository
baseurl=https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/el\$releasever/
gpgcheck=0
enabled=1
" > gitlab-ce.repo

sudo chown root:root gitlab-ce.repo
sudo mv gitlab-ce.repo /etc/yum.repos.d/

sudo yum makecache
sudo yum install gitlab-ce
