#! /usr/bin/env bash

# if [ -n "$ZSH_VERSION" ]; then
#   echo "zzzzzzzsh"
# else
#   echo "bbbbbbash"
# fi

# zsh_list=$(grep '/bin/zsh' '/etc/shells')
# zsh_list=$(grep '/usr/bin/zsh' '/etc/shells')
# echo ${zsh_list}

# if [ -e "/bin/zsh" ]; then
# if [ -e ${zsh_list} ] && [ -x ${zsh_list} ]; then
# if [[ -e ${zsh_list} && -x ${zsh_list} ]]; then
# if [ -e $(grep '/bin/zsh' '/etc/shells') ]; then
# if [ -e $(grep '/usr/bin/zsh' '/etc/shells') ]; then
# if [ -e "" ]; then
# if [ ! -z ${zsh_list} ]; then
# if [ ! -z ${ZSH_VERSION} ]; then
# if [ ! -z $(grep '/bin/zsh' '/etc/shells') ]; then
#   echo "zzzzzzzsh"
# fi

# echo $HOME
# function func0 () {
#   cd ..
# }
# function func1 () {
#   func0
#   echo $HOME
# }
# func1

# echo "$0"
# echo "$1"
# if [ $0 = "l" ]; then
#   echo "local install"
# else
#   echo "url install"
# fi

# vim +PlugInstall
# echo "Finish vim plugin."

# echo "Modify \"hostname\" ? Using method 2 ."
# cat << END_OF_ECHO
# method 1
# $ vi /etc/hosts
# END_OF_ECHO

cat > wow.txt << ECHO_END
env=~/.ssh/agent.env
agent_load_env () { test -f "\$env" && . "\$env" >| /dev/null ; }
ECHO_END

