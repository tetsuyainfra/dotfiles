#!/usr/bin/env bash
#set -e
# detect what we have
if [  $(uname -a | grep -c "Microsoft") -eq 1 ]; then
    export ISWSL=1 # WSL 1
elif [ $(uname -a | grep -c "microsoft") -eq 1 ]; then
    export ISWSL=2 # WSL 2
else
    export ISWSL=0
fi

function dotdir() {
  echo "$(cd $(dirname $0); pwd)"
}
DOT_DIR=`dotdir`


function ConfirmGitInfo(){
  GIT_USERNAME=${GIT_USERNAME:=$(git config --get user.name)}
  if [ -z "${GIT_USERNAME}" ] ; then
    read -p "GIT_USERNAME:" GIT_USERNAME
  fi
  GIT_EMAIL=${GIT_EMAIL:=$(git config --get user.email)}
  if [ -z "${GIT_EMAIL}" ] ; then
    read -p "GIT_EMAIL:" GIT_EMAIL
  fi
}

function ConfirmExecution() {
echo "GIT_USERNAME: $GIT_USERNAME"
echo "GIT_EMAIL   : $GIT_EMAIL"

read -p "ok? (y/N): " yn
case "$yn" in [yY]*) ;; *) echo "abort." ; exit ;; esac
}


ConfirmGitInfo
set -e
ConfirmExecution

set -x


DOTTER_LOCAL_FILE="${DOT_DIR}/.dotter/local.toml"
DOTTER_LOCAL_SKEL="${DOT_DIR}/.dotter/skel/local_ubuntu.toml"

if [ ! -e "${DOTTER_LOCAL_FILE}" ] ; then
cp ${DOTTER_LOCAL_SKEL} ${DOTTER_LOCAL_FILE}
fi

## dotter
pushd ${DOT_DIR}

./dotter

## GIT
git config -f ~/.config/git/config.local user.name ${GIT_USERNAME}
git config -f ~/.config/git/config.local user.email ${GIT_EMAIL}

popd

## WSL2 support ssh
#if [ ${ISWSL} -eq 2 ]; then
#  windows_destination="/mnt/d/opt/bin/wsl2-ssh-pageant.exe"
#  linux_destination="$HOME/.ssh/wsl2-ssh-pageant.exe"
#  mkdir -p $HOME/.ssh
#  chmod +x "$windows_destination"
#  ln -s $windows_destination $linux_destination
#fi


