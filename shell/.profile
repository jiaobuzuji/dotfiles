# vim:fdm=marker fen

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
[ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ] && source "$HOME/.bashrc"

DOTFILES="${HOME}/repos/dotfiles.git"


# aliases {{{1
# alias which='alias | /usr/bin/which --tty-only --read-alias --show-dot --show-tilde'

alias mv='mv -i'
alias rm='rm -i'
alias cp='cp -i'
alias l.='ls .* -d'

alias gv='gvim'
alias v='vim'
alias vi='vim -u NONE'

alias ssh="ssh -Y"

# export {{{1
export PATH="$HOME/.local/bin:$PATH"
export EDITOR='vim'
export TERM=xterm-256color
export MANPATH="/usr/local/man:$MANPATH"
# export MANPAGER="vim -c MANPAGER -"
export LANG=en_US.UTF-8


# misc {{{1

# custom config {{{1
[ -f "$HOME/" ] && source "$HOME.sh"
