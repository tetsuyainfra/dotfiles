!/bin/sh
set -x

DOT_DIR=$(cd $(dirname $0);pwd)
echo "DOT_DIR: $DOT_DIR"

# if root or sudo will be exit !!
if [ "`whoami`" != "root" ]; then
  echo "you should exec root privilege"
  exit 1
fi


## Keepass XC
if ! $(type keepassxc > /dev/null 2>&1); then
  add-apt-repository ppa:phoerious/keepassxc
  apt update
  apt install keepassxc
fi
