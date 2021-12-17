# zsh configuration
# Author:   jiaobuzuji,jiaobuzuji@163.com
# Github:   https://github.com/jiaobuzuji
#"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=${HOME}/repos/ohmyzsh.git

# for faster loading,we use zsh buildin command zcompile
# to compile the .zshrc
if [ ! -f ~/.zshrc.zwc -o ~/.zshrc -nt ~/.zshrc.zwc ]; then
    zcompile ~/.zshrc
fi


# oh-my-zsh setting {{{1
# -----------------------------------------------------------------
# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="robbyrussell"
ZSH_THEME="mortalscumbag"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

# plugins=(
#   osx autojump history-substring-search command-not-found sudo
#   git github git-flow svn web-search
# )
plugins=(
  autojump history-substring-search command-not-found sudo
  git github git-flow svn web-search
  zsh-completions zsh-autosuggestions zsh-syntax-highlighting
)

zmodload zsh/terminfo
source "$ZSH/oh-my-zsh.sh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[[ -s "/etc/profile.d/autojump.sh" ]] && source "/etc/profile.d/autojump.sh"
# [[ -s "$HOME/.autojump/etc/profile.d/autojump.sh" ]] && source "$HOME/.autojump/etc/profile.d/autojump.sh"
autoload -U compinit promptinit
compinit


# keybinds {{{1
# -----------------------------------------------------------------
# emacs keybinds
bindkey -e

# History completion
# autoload history-search-end
# zle -N history-beginning-search-backward-end history-search-end
# zle -N history-beginning-search-forward-end history-search-end
# bindkey "^p" history-beginning-search-backward-end
# bindkey "^n" history-beginning-search-forward-end
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down

# Like bash
bindkey "^u" backward-kill-line

# autosuggestions
bindkey '\el' autosuggest-accept # Alt+l

# aliases {{{1
# -----------------------------------------------------------------
# Global aliases {{{2
alias -g A="| awk"
alias -g G="| grep"
alias -g GV="| grep -v"
alias -g H="| head"
alias -g L="| $PAGER"
alias -g P=' --help | less'
alias -g R="| ruby -e"
alias -g S="| sed"
alias -g T="| tail"
alias -g V="| vim -R -"
alias -g U=' --help | head'
alias -g W="| wc"

# Suffix aliases {{{2
# you can type filename with following subffix and zsh will open it with default specifial command
alias -s zip=zipinfo
alias -s tgz=gzcat
alias -s gz=gzcat
alias -s tbz=bzcat
alias -s bz2=bzcat
alias -s java=vim
alias -s c=vim
alias -s h=vim
alias -s C=vim
alias -s cpp=vim
alias -s txt=vim
alias -s xml=vim
alias -s html=firefox
alias -s xhtml=firefox
alias -s gif=display
alias -s jpg=display
alias -s jpeg=display
alias -s png=display
alias -s bmp=display
alias -s mp3=amarok
alias -s m4a=amarok
alias -s ogg=amarok
alias -s gz='tar -xzvf'
alias -s xz='tar -xJvf'
alias -s bz2='tar -xjvf'
alias -s zip='unzip'
# Other aliases {{{2
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# -----------------------------------------------------------------
# key bindings
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
# bindkey "\e[5~" beginning-of-history
# bindkey "\e[6~" end-of-history
# bindkey "\e[3~" delete-char
# bindkey "\e[2~" quoted-insert
# bindkey "\e[5C" forward-word
# bindkey "\eOc" emacs-forward-word
# bindkey "\e[5D" backward-word
# bindkey "\eOd" emacs-backward-word
# bindkey "\ee[C" forward-word
# bindkey "\ee[D" backward-word
# bindkey "^H" backward-delete-word
# for rxvt
bindkey "\e[8~" end-of-line
bindkey "\e[7~" beginning-of-line
# for non RH/Debian xterm, can't hurt for RH/DEbian xterm
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
# for freebsd console
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
# # completion in the middle of a line
# bindkey '^i' expand-or-complete-prefix

# User configuration {{{1
# -----------------------------------------------------------------
for file in $HOME/repos/dotfiles.git/shell/{basic,extra}.sh; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# added by travis gem
# [ -f ${HOME}/.travis/travis.sh ] && source ${HOME}/.travis/travis.sh



# -----------------------------------------------------------------
# vim:fdm=marker

