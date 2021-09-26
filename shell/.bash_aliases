# -----------------------------------------------------------------
# Author : Jiaobuzuji@163.com
# -----------------------------------------------------------------
# vim:fdm=marker

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ls='ls -G --color=auto'
alias l='ls -CF --color=auto'
alias ll='ls -alh --color=auto'
alias la='ls -A --color=auto'
alias l.='ls .* -d --color=auto'

alias mv='mv -i'
alias rm='rm -i'
alias cp='cp -i'

alias gv='gvim'
alias v='vim'
# alias vi='vim -u NONE' # pure vim
# alias gvi='gvim -u NONE'

alias locate='locate -r'  #regular expression support

alias ga='git add'
alias gaa='git add --all'
alias gcam='git commit -a -m'
alias gd='git diff'
alias gl='git pull gitee master && git pull'
alias gp='git push gitee master && git push'
alias gss='git status'
alias gsta='git stash save'
alias gstaa='git stash apply'
alias gstc='git stash clear'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gsts='git stash show --text'

alias tarc='tar -Jcvhf "hello.tar.xz" --exclude-vcs --exclude-vcs-ignores'
