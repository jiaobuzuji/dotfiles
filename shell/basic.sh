# -----------------------------------------------------------------
# Author : Jiaobuzuji@163.com
# -----------------------------------------------------------------
# vim:fdm=marker

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
umask 022

# [ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ] && source "$HOME/.bashrc"
# [ -n "$ZSH_VERSION" ] && zcompile "$HOME/.zshrc"


# export {{{1
export PATH="$HOME/.local/bin:$PATH"
export EDITOR='nvim'
export SVN_EDITOR='nvim'
export TERM='xterm-256color'
export MANPATH="/usr/local/man:$MANPATH"
export MANPAGER="vim -c MANPAGER -"
export LANG=en_US.UTF-8
# export SSH_KEY_PATH="~/.ssh/rsa_id"

WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
# improved less option
export LESS='--tabs=4 --no-init --LONG-PROMPT --ignore-case --quit-if-one-screen --RAW-CONTROL-CHARS'


# aliases {{{1
alias mv='mv -i'
alias rm='rm -i'
alias cp='cp -i'
alias l.='ls .* -d'
alias lg='lazygit'

# alias gv='gvim'
# alias v='vim'
# alias vi='vim -u NONE' # pure vim
# alias gvi='gvim -u NONE'
alias vi='vim'
alias gv='gvim'
alias v='nvim'
alias nv='nvim-qt'
alias c='bcompare'

alias ssh='ssh -Y' # Enables trusted X11 forwarding
# alias sshn='ssh -YN' # Just forwarding ports

alias path='echo -e ${PATH//:/\\n}' # Print each PATH entry on a separate line
alias locate='locate -r'  #regular expression support


# misc {{{1
# which tmux > /dev/null 2>&1
# if [ $? -eq 0 ]; then
#   case $- in *i*) # interactive shell
#     [ -z "$TMUX" ] && exec $(tmux -2)
#   esac
# fi
