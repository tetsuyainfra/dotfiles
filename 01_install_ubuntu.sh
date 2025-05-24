#!/usr/bin/env bash
# usage:
#   ./install_ubunthy.sh
#   ENABLE_ALL=1    ./install_ubuntu.sh     # install all package
#   ENABLE_PYTHON=1 ./install_ubuntu.sh  # install default and python building packages
#

set -e

major_ver=$(lsb_release -r -s | cut -d. -f1)

function dotdir() {
  echo "$(cd $(dirname $0); pwd)"
}
DOT_DIR=`dotdir`

function link_file_force() {
  ln --force --no-dereference -s "${DOT_DIR}/$1" "$2"
}

# sudo apt update
ENABLE_DEFAULT=${ENABLE_DEFAULT:=1}
source ${DOT_DIR}/_versions.sh
#INSTALL_ASDF_VERSION=${INSTALL_ASDF_VERSION:=0.11.1}
#INSTALL_PYTHON_VERSION=${INSTALL_PYTHON_VERSION:=3.13} # install 3.13.X
#INSTALL_RUBY_VERSION=${INSTALL_RUBY_VERSION:=3.2.2}
#INSTALL_NODE_VERSION=${INSTALL_NODE_VERSION:=20.9.0}
#INSTALL_GO_VERSION=${INSTALL_GO_VERSION:=1.21.4}

if [[ "X${ENABLE_ALL}" == "X1" ]]; then
ENABLE_DEFAULT=1
ENABLE_NIXOS=
ENABLE_RUST=1
ENABLE_ASDF=
ENABLE_PYTHON=1
ENABLE_RUBY=1
ENABLE_NODE=1
ENABLE_GO=1
ENABLE_TERRAFORM=${ENABLE_TERRAFORM}
fi

echo "ENABLE_DEFAULT: $ENABLE_DEFAULT"
echo "ENABLE_NIXOS:   $ENABLE_NIXOS"
echo "ENABLE_RUST:    $ENABLE_RUST"
echo "ENABLE_ASDF:    $ENABLE_ASDF"
echo "ENABLE_PYTHON:  $ENABLE_PYTHON"
echo "ENABLE_RUBY:    $ENABLE_RUBY"
echo "ENABLE_NODE:    $ENABLE_NODE"
echo "ENABLE_GO:    $ENABLE_GO"
echo "ENABLE_TERRAFORM: $ENABLE_TERRAFORM"


if [[ "X${ENABLE_DEFAULT}" == "X1" ]]; then
# socat for ssh-agent on windows service
ADD_PACKAGES="socat"
# shell extensions
ADD_PACKAGES+=" direnv byobu git-flow"
# sometime use devlopping
ADD_PACKAGES+=" pkgconf jq"
fi
# if WSL
if [[ "$(uname -r)" == *microsoft* ]]; then
ADD_PACKAGES+=" wslu"
fi

# ASDF
#if [ -n "${ENABLE_ASDF}" ]; then
#ADD_PACKAGES+=$(echo " curl git")
#fi

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
  libdb-dev \
  libopencv-dev \
  tk-dev )
fi


# Ruby
if [ -n "${ENABLE_RUBY}" ]; then
# Before v3.2.0, needs rust(for yjit)
ENABLE_RUST=1

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
ADD_PACKAGES+=" liblzma-dev patch "

# for sqlite3
ADD_PACKAGES+=" libsqlite3-dev "
fi

# Node
if [ -n "${ENABLE_NODE}" ]; then
ADD_PACKAGES+=$(echo  " build-essential" \
  python3 \
  g++ \
  make)
  if [[ "${major_ver}" == "22" ]]; then
    ADD_PACKAGES+=$(echo  " python3-distutils")
  fi
fi


################################################################################
# Install packages
################################################################################
# sudo apt install --dry-run $ADD_PACKAGES
if [[ "$(uname -r)" == *microsoft* ]]; then
  echo "on WSL"
  if [[ "${major_ver}" == "22" ]]; then
    sudo apt install -y software-properties-common
    # sudo add-apt-repository -y ppa:wslutilities/wslu
    sudo apt update
  fi
fi
sudo apt install -y $ADD_PACKAGES

################################################################################
# Install NixOS(package manager)
################################################################################
if [ -n "${ENABLE_NIXOS}" ]; then
  # WSL2の場合、SingleUserModeでインストールする必要がある
  if [ ! -e /nix ] ; then
    sh <(curl -L https://nixos.org/nix/install) --no-daemon --no-modify-profile
  fi

  if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then
    echo Enable Nix OS temporaly
    . $HOME/.nix-profile/etc/profile.d/nix.sh

    # for github action's Debug
    echo "Add Packages via nix-env"
    nix-env -iA nixpkgs.act
  fi
fi


################################################################################
# Install *env
################################################################################
# Rust
if [ -n "${ENABLE_RUST}" ]; then
  echo "Install Rust"
  if [ ! -e ~/.cargo ]; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
  fi

  if [ -e "$HOME/.cargo/env" ]; then
    source $HOME/.cargo/env
    rustup component add rust-analyzer rls
    rustup +nightly component add rust-analyzer
    cargo install git-cliff
    # pretty print rust source (using rustc nightly build)
    cargo install cargo-update
    cargo install cargo-outdated
    cargo install cargo-expand
    cargo install cargo-watch
    cargo install cross
    cargo install tokio-console
    cargo install sccache
  fi
fi



# Go
#if [ -n "${ENABLE_GO}" ]; then
#  echo "Install Go"
#  if [ ! -e ~/.goenv ]; then
#    git clone https://github.com/syndbg/goenv.git ~/.goenv
#  fi
#
#  if [ -z "$GOENV_ROOT" ]; then
#    export GOENV_ROOT="$HOME/.goenv"
#    export PATH="$GOENV_ROOT/bin:$PATH"
#    if command -v goenv 1>/dev/null 2>&1; then
#      eval "$(goenv init -)"
#    fi
#    export PATH="$GOROOT/bin:$PATH"
#    export PATH="$PATH:$GOPATH/bin"
#  fi
#  goenv install --skip-existing $INSTALL_GO_VERSION
#  goenv global $INSTALL_GO_VERSION
#  goenv rehash
#fi

# Terraform
if [ -n "${ENABLE_TERRAFORM}" ]; then
  wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
  sudo apt update && sudo apt install terraform
fi
