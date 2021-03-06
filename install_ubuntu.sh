#!/usr/bin/env bash
# usage:
#   ./install_ubunthy.sh
#   ENABLE_ALL=1 ./install_ubunthy.sh     # install all package
#   ENABLE_PYTHON=1 ./install_ubunthy.sh  # install default and python building packages
#

set -e

function dotdir() {
  echo "$(cd $(dirname $0); pwd)"
}
DOT_DIR=`dotdir`

function link_file_force() {
  ln --force --no-dereference -s "${DOT_DIR}/$1" "$2"
}

# sudo apt update
ENABLE_DEFAULT=${ENABLE_DEFAULT:=1}
INSTALL_PYTHON_VERSION=${INSTALL_PYTHON_VERSION:=3.9.1}
INSTALL_RUBY_VERSION=${INSTALL_RUBY_VERSION:=2.7.2}
INSTALL_NODE_VERSION=${INSTALL_NODE_VERSION:=14.16.0}

if [[ "X${ENABLE_ALL}" == "X1" ]]; then
ENABLE_DEFAULT=1
ENABLE_PYTHON=1
ENABLE_RUBY=1
ENABLE_NODE=1
ENABLE_RUST=1
fi

echo "ENABLE_DEFAULT: $ENABLE_DEFAULT"
echo "ENABLE_PYTHON:  $ENABLE_PYTHON"
echo "ENABLE_RUBY:    $ENABLE_RUBY"
echo "ENABLE_NODE:    $ENABLE_NODE"
echo "ENABLE_RUST:    $ENABLE_RUST"


if [[ "X${ENABLE_DEFAULT}" == "X1" ]]; then
# socat for ssh-agent on windows service
ADD_PACKAGES="socat"
# shell extensions
ADD_PACKAGES+=" direnv byobu"
fi


# Python3
if [ -n "${ENABLE_PYTHON}" ]; then
ADD_PACKAGES+=$(echo  " build-essential" \
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
  libdb-dev)
fi


# Ruby
if [ -n "${ENABLE_RUBY}" ]; then
ADD_PACKAGES+=$(echo  " build-essential" \
  autoconf \
  bison \
  build-essential \
  libssl-dev \
  libyaml-dev \
  libreadline-dev \
  zlib1g-dev \
  libncurses5-dev \
  libffi-dev \
  libgdbm6 \
  libgdbm-dev \
  libdb-dev)

# for nokogiri gem
# ADD_PACKAGES+=""
fi

# Node
if [ -n "${ENABLE_NODE}" ]; then
ADD_PACKAGES+=$(echo  " build-essential" \
  python3 \
  python3-distutils \
  g++ \
  make)
fi




################################################################################
# Install packages
################################################################################
# sudo apt install --dry-run $ADD_PACKAGES
sudo apt install -y $ADD_PACKAGES



# Python - Pyenv
if [ -n "${ENABLE_PYTHON}" ]; then
  echo "Install pyenv"
  if [ ! -e ~/.pyenv ]; then
  	git clone https://github.com/pyenv/pyenv.git ~/.pyenv
  fi
  if [ ! -e ~/.pyenv/plugins/pyenv-virtualenv ]; then
  	git clone https://github.com/yyuu/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv
  fi

  if [ -z "$PYENV_SHELL" ] ; then
  	export PYENV_ROOT="$HOME/.pyenv"
  	export PATH="$PYENV_ROOT/bin:$PATH"
  	if command -v pyenv 1>/dev/null 2>&1; then
  		eval "$(pyenv init -)"
  		eval "$(pyenv virtualenv-init -)"
  	fi
  fi
  pyenv install --skip-existing $INSTALL_PYTHON_VERSION
  pyenv global $INSTALL_PYTHON_VERSION
  pyenv rehash
fi

# Ruby - rbenv
if [ -n "${ENABLE_RUBY}" ]; then
  echo "Install rbenv"
  if [ ! -e ~/.rbenv ]; then
  	git clone https://github.com/rbenv/rbenv.git ~/.rbenv
  fi
  if [ ! -e ~/.rbenv/plugins/ruby-build ]; then
  	git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
  fi
  if [ ! -e ~/.rbenv/plugins/rbenv-default-gems ]; then
    git clone https://github.com/rbenv/rbenv-default-gems.git ~/.rbenv/plugins/rbenv-default-gems
  fi
  link_file_force "ruby/default-gems" "${HOME}/.rbenv/default-gems"

  if [ -z "$RBENV_SHELL" ]; then
    export PATH="$HOME/.rbenv/bin:$PATH"
  	if command -v rbenv 1>/dev/null 2>&1; then
      eval "$(rbenv init -)"
  	fi
  fi
  rbenv install --skip-existing $INSTALL_RUBY_VERSION
  rbenv global $INSTALL_RUBY_VERSION
  rbenv rehash
fi

# Node
if [ -n "${ENABLE_NODE}" ]; then
  echo "Install nodenv"
  if [ ! -e ~/.nodenv ]; then
    git clone https://github.com/nodenv/nodenv.git ~/.nodenv
    # to speed up
    pushd ~/.nodenv
      src/configure && make -C src
    popd
  fi
  if [ ! -e ~/.nodenv/plugins/node-build ]; then
    # git clone https://github.com/nodenv/node-build.git "$(nodenv root)"/plugins/node-build
    git clone https://github.com/nodenv/node-build.git ~/.nodenv/plugins/node-build
  fi

  if [ -z "$NODENV_SHELL" ]; then
    export PATH="$HOME/.nodenv/bin:$PATH"
  	if command -v nodenv 1>/dev/null 2>&1; then
      eval "$(nodenv init -)"
  	fi
  fi
  nodenv install --skip-existing $INSTALL_NODE_VERSION
  nodenv global $INSTALL_NODE_VERSION
  npm install --global yarn
  nodenv rehash
fi


# Rust
if [ -n "${ENABLE_RUST}" ]; then
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi


# echo "Install anyenv"
# if [ ! -e ~/.anyenv ]; then
#   git clone https://github.com/anyenv/anyenv ~/.anyenv
# fi
# export PATH="$HOME/.anyenv/bin:$PATH"
# eval "$(anyenv init -)"
# if [ ! -e ~/.config/anyenv/anyenv-install ]; then
#   anyenv install --force-init
# else
#   anyenv install --update
# fi

# if [ -n "${ENABLE_PYTHON}" ]; then
#   anyenv install pyenv
# fi
# if [ -n "${ENABLE_RUBY}" ]; then
#   anyenv install rbenv
# fi