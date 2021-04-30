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
sudo mv gitlab-all.repo /etc/yum.repos.d/

sudo yum makecache
sudo EXTERNAL_URL="http://127.0.0.1:8081" yum install gitlab-ce gitlab-runner
