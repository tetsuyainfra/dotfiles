#!/bin/sh
set -x

# xcode-select --install
# /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

DOT_DIR=$(cd $(dirname $0);pwd)

echo "DOT_DIR: $DOT_DIR"

##
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


