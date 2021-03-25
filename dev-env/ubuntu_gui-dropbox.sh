#!/bin/bash
set -x

DOT_DIR=$(cd $(dirname $0);pwd)
echo "DOT_DIR: $DOT_DIR"

# if root or sudo will be exit !!
if [ "`whoami`" != "root" ]; then
  echo "you should exec root privilege"
  exit 1
fi

if ! $(type dropbox > /dev/null 2>&1); then
  apt-key adv --keyserver pgp.mit.edu --recv-keys 1C61A2656FB57B7E4DE0F4C1FC918B335044912E
  add-apt-repository "deb https://linux.dropbox.com/ubuntu $(lsb_release -sc) main"
  apt install dropbox
fi

if ! $(type keepassxc > /dev/null 2>&1); then
  add-apt-repository ppa:phoerious/keepassxc
  apt update
  apt install keepassxc
fi