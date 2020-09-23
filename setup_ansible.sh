#!/usr/bin/env bash
set -ex

USE_PYTHON_VERSION=3.8.5

# pyenv setup
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

## python3
sudo apt install -y \
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

# install python and ansible in directory
pyenv install $USE_PYTHON_VERSION
pyenv virtualenv -f $USE_PYTHON_VERSION use_ansible
pushd ansible
pyenv local use_ansible
pip3 install ansible
popd

