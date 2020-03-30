#!/usr/bin/env bash
set -ex

source $(cd $(dirname $0); pwd)/_utils.sh

# xcode-select --install
# /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

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

#### SHELL
# bash
ln -nsf ${DOT_DIR}/bash/bash_profile ~/.bash_profile
ln -nsf ${DOT_DIR}/bash/bashrc       ~/.bashrc
# fish
ln -nsf ${DOT_DIR}/fish ~/.config/fish
# zsh
ln -nsf ${DOT_DIR}/zsh/zshenv     ~/.zshenv
mkdir -p ~/.zsh
ln -nsf ${DOT_DIR}/zsh/zshprofile ~/.zsh/.zshprofile
ln -nsf ${DOT_DIR}/zsh/zshrc      ~/.zsh/.zshrc
# zplug - zsh
if [ ! -e ~/.zsh/zplug ]; then
	git clone https://github.com/zplug/zplug ~/.zsh/zplug
fi
# zplugin - zsh
if [ ! -e ~/.zsh/zplugin ]; then
	mkdir -p ~/.zsh/zplugin
	git clone https://github.com/zdharma/zplugin.git ~/.zsh/zplugin/bin
fi

# CLI
ln -nsf ${DOT_DIR}/byobu ~/.byobu


#### DEV-TOOLS
# git
ln -nsf ${DOT_DIR}/git ~/.config/git
touch ~/.config/git/config.local
# direnv
ln -nsf ${DOT_DIR}/direnv ~/.config/direnv



