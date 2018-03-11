# vim:fdm=marker fen

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# [ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ] && source "$HOME/.bashrc"
# [ -n "$ZSH_VERSION" ] && zcompile "$HOME/.zshrc"

# DOTFILES="${HOME}/repos/dotfiles.git"

# aliases {{{1
# alias mv='mv -i'
# alias rm='rm -i'
# alias cp='cp -i'
# alias l.='ls .* -d'

# alias gv='gvim'
# alias v='vim'
# alias vi='vim -u NONE'
# alias gvi='gvim -u NONE'

# alias ssh='ssh -Y'

# # export {{{1
export PATH="$HOME/.local/bin:$PATH"
export EDITOR='vim'
export TERM=xterm-256color
export MANPATH="/usr/local/man:$MANPATH"
# export MANPAGER="vim -c MANPAGER -"
export LANG=en_US.UTF-8


# misc {{{1
# export NVM_DIR="$HOME/.nvm"  # Node.js  HEXO Blog
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# custom config {{{1
# [ -f "$HOME/.shell/profile" ] && source "$HOME/.shell/profile"
