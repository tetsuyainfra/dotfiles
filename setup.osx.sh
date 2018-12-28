#!/bin/sh
set -x

# xcode-select --install
# /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

DOT_DIR=$(cd $(dirname $0);pwd)

echo "DOT_DIR: $DOT_DIR"

mkdir -p ~/.config

ln -nsf ${DOT_DIR}/fish ~/.config/fish

ln -nsf ${DOT_DIR}/git ~/.config/git
touch ~/.config/git/config.local


