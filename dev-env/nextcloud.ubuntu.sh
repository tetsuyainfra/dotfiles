#!/bin/bash
set -x

DOT_DIR=$(cd $(dirname $0);pwd)
echo "DOT_DIR: $DOT_DIR"

# if root or sudo will be exit !!
if [ "`whoami`" != "root" ]; then
  echo "you should exec root privilege"
  exit 1
fi

if ! $(type nextcloud > /dev/null 2>&1); then
	add-apt-repository ppa:nextcloud-devs/client
	apt update
	apt install -y nextcloud-client
fi

