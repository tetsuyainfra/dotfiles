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

function link_file_force() {
  ln --force --no-dereference -s "${DOT_DIR}/$1" "$2"
}
function link_dir_force() {
  ln --force --no-dereference -s "${DOT_DIR}/$1" "$2"
}

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

if [ ! `echo "${MSYS}" | grep "winsymlinks"` ] ; then
  echo \$MSYSに設定が含まれていません
  echo MSYS=winsymlinks:lnk でショートカットを利用したシンボリックリンクを作成
  echo MSYS=winsymlinks:nativestrict でネイティブのシンボリックリンクを作成
  exit 1
fi

ConfirmGitInfo
set -e
ConfirmExecution

set -x

# creat $HOME/config
mkdir -p $HOME/.config

## GIT
link_dir_force "git" "${HOME}/.config/git"
git config -f ~/.config/git/config.local user.name ${GIT_USERNAME}
git config -f ~/.config/git/config.local user.email ${GIT_EMAIL}

# install Bash
link_file_force "bash/bash_aliases" "${HOME}/.bash_aliases"
link_file_force "bash/bash_profile" "${HOME}/.bash_profile"
link_file_force "bash/bash_completion.d" "${HOME}/.bash_completion.d"