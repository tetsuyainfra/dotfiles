#!/usr/bin/env bash
# usage:
#   ./install_ubunthy.sh
#   ENABLE_ALL=1 ./install_ubunthy.sh     # install all package
#   ENABLE_PYTHON=1 ./install_ubunthy.sh  # install default and python building packages
#

set -e

# sudo apt update
ENABLE_DEFAULT=${ENABLE_DEFAULT:=1}

if [[ "X${ENABLE_ALL}" == "X1" ]]; then
ENABLE_DEFAULT=1
ENABLE_PYTHON=1
ENABLE_RUBY=1
fi

echo "ENABLE_DEFAULT: $ENABLE_DEFAULT"
echo "ENABLE_PYTHON:  $ENABLE_PYTHON"
echo "ENABLE_RUBY: $ENABLE_RUBY"

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
fi


# sudo apt install --dry-run $ADD_PACKAGES
sudo apt install -y $ADD_PACKAGES
