#!/bin/sh
set -x

# xcode-select --install
# /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

source $(cd $(dirname $0); pwd)/_utils.sh

### ~/.
## ruby
ln -sf ${DOT_DIR}/gemrc ~/.gemrc

### .config
mkdir -p ~/.config
# fish
ln -nsf ${DOT_DIR}/fish ~/.config/fish
# git
ln -nsf ${DOT_DIR}/git ~/.config/git
touch ~/.config/git/config.local


