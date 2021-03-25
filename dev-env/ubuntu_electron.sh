#!/bin/sh
set -x

DOT_DIR=$(cd $(dirname $0);pwd)
echo "DOT_DIR: $DOT_DIR"

if ! $(type wine > /dev/null 2>&1); then
  # enable i386
  dpkg --add-architecture i386

  ## Wine HQ
  curl https://dl.winehq.org/wine-builds/winehq.key | apt-key add -
  # 18.04
  # sudo apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main'
  apt-add-repository "deb https://dl.winehq.org/wine-builds/ubuntu/ $(lsb_release -cs) main"

  apt update
  apt install --install-recommends winehq-stable
fi


