#!/bin/sh
set -x

DOT_DIR=$(cd $(dirname $0);pwd)
echo "DOT_DIR: $DOT_DIR"

## Linux-brew
apt install -y \
  build-essential \
  curl git m4 ruby texinfo \
  libbz2-dev \
  libcurl4-openssl-dev \
  libexpat-dev \
  libncurses-dev \
  zlib1g-dev \
  gettext
# gettextはおまじない
if [ ! -e /home/linuxbrew ]; then
  sudo -u ${SUDO_USER:-${USER}} sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"

  # config for *sh
  test -d /home/linuxbrew/.linuxbrew && eval $(sudo -u ${SUDO_USER:-${USER}} /home/linuxbrew/.linuxbrew/bin/brew shellenv)
  test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
  echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile
fi
