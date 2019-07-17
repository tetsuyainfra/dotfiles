#!/bin/sh
set -x

# xcode-select --install
# /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

DOT_DIR=$(cd $(dirname $0);pwd)

echo "DOT_DIR: $DOT_DIR"

## apt use mirror
not_mirror_count=`grep --count '^deb.*http://archive.ubuntu.com/' /etc/apt/sources.list`
if [ $not_mirror_count -gt 0 ]; then
# select which one
# sed -i.bak -e "s%http://archive.ubuntu.com/ubuntu/%http://jp.archive.ubuntu.com/ubuntu/%g" /etc/apt/sources.list
# sed -i.bak -e "s%http://archive.ubuntu.com/ubuntu/%http://ftp.iij.ad.jp/pub/linux/ubuntu/archive/%g" /etc/apt/sources.list
  sed -i.bak -e "s%http://archive.ubuntu.com/ubuntu/%http://ftp.jaist.ac.jp/pub/Linux/ubuntu/%g" /etc/apt/sources.list
  apt update
fi


## fish shell
if [ type fish > /dev/null 2>&1 ]; then
  apt-add-repository -y ppa:fish-shell/release-3
  apt update
  apt-get install -y fish
fi


## ruby
apt install -y \
	autoconf \
	bison \
	build-essential \
	libssl-dev \
	libyaml-dev \
	libreadline6-dev \
	zlib1g-dev \
	libncurses5-dev \
	libffi-dev \
	libgdbm5 \
	libgdbm-dev

## python3
apt install -y \
    build-essential \
    libreadline-dev \
    libncursesw5-dev \
    libssl-dev \
    libsqlite3-dev \
    libgdbm-dev \
    libbz2-dev \
    liblzma-dev \
    zlib1g-dev \
    uuid-dev \
    libffi-dev \
    libdb-dev
# tkが必要な時
# apt install -y tk-dev
# equal command
# sudo apt build-dep python3.7




### .config


