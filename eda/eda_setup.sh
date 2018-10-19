#!/usr/bin/env bash

# -----------------------------------------------------------------
# Author : Jiaobuzuji@163.com
# -----------------------------------------------------------------

# SETUP FUNCTIONS {{{1
# -----------------------------------------------------------------
function lnif() {
  if [ -e "$1" ]; then
    ln -sfT "$1" "$2"
  fi
}

# Environment {{{1
[ -z "$REPO_PATH" ] && REPO_PATH="$HOME/repos"
[ -z "$EDATOOLS" ]  && EDATOOLS="${HOME}/.opt"

# Setup {{{1
# -----------------------------------------------------------------
# echo " Enter FULL Path !! "
# read -p "Where is EDA Tools Path ? ($HOME/.opt) : " ans

mkdir -p ${EDATOOLS}
lnif "$REPO_PATH/dotfiles.git/eda/eda_server.sh" "${EDATOOLS}/eda_server.sh"
lnif "$REPO_PATH/dotfiles.git/eda/eda_env.sh" "${EDATOOLS}/eda_env.sh"

sudo cat >> "/etc/rc.local" << ECHO_END

export EDATOOLS="${EDATOOLS}"
if [ -f \${EDATOOLS}/eda_server.sh ]; then
  source \${EDATOOLS}/eda_server.sh
fi
ECHO_END

# -----------------------------------------------------------------
# vim:fdm=marker
