#!/bin/sh
set -x

# xcode-select --install
# /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

DOT_DIR=$(cd $(dirname $0);pwd)

echo "DOT_DIR: $DOT_DIR"

### ~/.
## ruby
ln -sf ${DOT_DIR}/gemrc ~/.gemrc
if [ ! -e ~/.rbenv ]; then
	git clone https://github.com/rbenv/rbenv.git ~/.rbenv
fi
if [ ! -e ~/.rbenv/plugins/ruby-build ]; then
	git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
fi

## python3
if [ ! -e ~/.pyenv ]; then
	git clone https://github.com/pyenv/pyenv.git ~/.pyenv
fi

### bin
ln -nsf ${DOT_DIR}/bin ~/bin

### .config
mkdir -p ~/.config
# fish
ln -nsf ${DOT_DIR}/fish ~/.config/fish
# git
ln -nsf ${DOT_DIR}/git ~/.config/git
touch ~/.config/git/config.local
# direnv
ln -nsf ${DOT_DIR}/direnv ~/.config/direnv



