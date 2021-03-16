#!/usr/bin/env bash
set -e

function dotdir() {
  echo "$(cd $(dirname $0); pwd)"
}
DOT_DIR=`dotdir`


function link_file() {
ln --no-dereference -s "${DOT_DIR}/$1" "$2"
}

function link_file_force() {
ln --force --no-dereference -s "${DOT_DIR}/$1" "$2"
}

function ConfirmGitInfo(){
  if [ -z "${GIT_USERNAME}" ] ; then
    read -p "GIT_USERNAME:" GIT_USERNAME
  fi
  if [ -z "${GIT_EMAIL}" ] ; then
    read -p "GIT_EMAIL:" GIT_EMAIL
  fi

  echo "GIT_USERNAME: $GIT_USERNAME"
  echo "GIT_EMAIL   : $GIT_EMAIL"
}

function ConfirmExecution() {
read -p "ok? (y/N): " yn
case "$yn" in [yY]*) ;; *) echo "abort." ; exit ;; esac
}


#ConfirmGitInfo
#ConfirmExecution

set -x

# creat $HOME/config
mkdir -p $HOME/.config

# install Bash
link_file_force "bash/bash_aliases" "${HOME}/.bash_aliases"
link_file_force "bash/bash_profile" "${HOME}/.bash_profile"

# install byobu
link_file_force "byobu" "${HOME}/.config/byobu"

# install direnv
link_file_force "direnv" "${HOME}/.config/direnv"

# install Git
link_file_force "git" "${HOME}/.config/git"
if [ -n "${GIT_USERNAME}" -a  -n "${GIT_EMAIL}" ]; then
git config -f .config/git/config.local --add user.name ${GIT_USERNAME}
git config -f .config/git/config.local --add user.email ${GIT_EMAIL}
fi

# Ruby
link_file_force "ruby/gemrc" "${HOME}/.gemrc"