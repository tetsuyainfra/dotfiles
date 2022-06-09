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


function link_file() {
ln --no-dereference -s "${DOT_DIR}/$1" "$2"
}


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


ConfirmGitInfo
set -e
ConfirmExecution

set -x

# creat $HOME/config
mkdir -p $HOME/.config

# install bin
link_dir_force "bin" "${HOME}/.bin"

# install Bash
link_file_force "bash/bash_aliases" "${HOME}/.bash_aliases"
link_file_force "bash/bash_profile" "${HOME}/.bash_profile"
link_file_force "bash/bash_completion.d" "${HOME}/.bash_completion.d"

# install vim
link_dir_force "vim" "${HOME}/.vim"

# install byobu
link_dir_force "byobu" "${HOME}/.config/byobu"

# install direnv
link_dir_force "direnv" "${HOME}/.config/direnv"

# install Git
link_dir_force "git" "${HOME}/.config/git"
if [ -n "${GIT_USERNAME}" -a  -n "${GIT_EMAIL}" ]; then
git config -f ~/.config/git/config.local --add user.name ${GIT_USERNAME}
git config -f ~/.config/git/config.local --add user.email ${GIT_EMAIL}
fi

# Ruby
link_file_force "ruby/gemrc" "${HOME}/.gemrc"

# inputrc
link_file_force "home-dir/inputrc" "${HOME}/.inputrc"


# WSL2 support ssh
if [ ${ISWSL} -eq 2 ]; then
  windows_destination="/mnt/d/opt/bin/wsl2-ssh-pageant.exe"
  linux_destination="$HOME/.ssh/wsl2-ssh-pageant.exe"
  mkdir -p $HOME/.ssh
  chmod +x "$windows_destination"
  ln -s $windows_destination $linux_destination
fi


