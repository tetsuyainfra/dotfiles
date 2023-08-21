#!/usr/bin/env bash
# usage:
#   ./install_ubunthy.sh
#   ENABLE_ALL=1    ./install_ubuntu.sh     # install all package
#   ENABLE_PYTHON=1 ./install_ubuntu.sh  # install default and python building packages
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
INSTALL_ASDF_VERSION=${INSTALL_ASDF_VERSION:=0.11.1}
INSTALL_PYTHON_VERSION=${INSTALL_PYTHON_VERSION:=3.11.3}
INSTALL_RUBY_VERSION=${INSTALL_RUBY_VERSION:=3.2.2}
INSTALL_NODE_VERSION=${INSTALL_NODE_VERSION:=18.17.1}
INSTALL_GO_VERSION=${INSTALL_GO_VERSION:=1.19.5}

if [[ "X${ENABLE_ALL}" == "X1" ]]; then
ENABLE_DEFAULT=1
ENABLE_NIXOS=1
ENABLE_RUST=1
ENABLE_ASDF=1
ENABLE_PYTHON=1
ENABLE_RUBY=1
ENABLE_NODE=1
ENABLE_GO=1
fi

echo "ENABLE_DEFAULT: $ENABLE_DEFAULT"
echo "ENABLE_NIXOS:   $ENABLE_NIXOS"
echo "ENABLE_RUST:    $ENABLE_RUST"
echo "ENABLE_ASDF:    $ENABLE_ASDF"
echo "ENABLE_PYTHON:  $ENABLE_PYTHON"
echo "ENABLE_RUBY:    $ENABLE_RUBY"
echo "ENABLE_NODE:    $ENABLE_NODE"
echo "ENABLE_GO:    $ENABLE_GO"


if [[ "X${ENABLE_DEFAULT}" == "X1" ]]; then
# socat for ssh-agent on windows service
ADD_PACKAGES="socat"
# shell extensions
ADD_PACKAGES+=" direnv byobu git-flow"
# sometime use devlopping
ADD_PACKAGES+=" pkgconf"
fi
# if WSL
if [[ "$(uname -r)" == *microsoft* ]]; then
ADD_PACKAGES+=" wslu"
fi

# ASDF
if [ -n "${ENABLE_ASDF}" ]; then
ADD_PACKAGES+=$(echo " curl git")
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
  python3-distutils \
  g++ \
  make)
fi


################################################################################
# Install packages
################################################################################
# sudo apt install --dry-run $ADD_PACKAGES
if [[ "$(uname -r)" == *microsoft* ]]; then
  echo "on WSL"
  sudo apt install -y software-properties-common
  sudo add-apt-repository ppa:wslutilities/wslu
  sudo apt update
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
# # ADFS - like anyenv
# if [ -n "${ENABLE_ASDF}" ]; then
#   echo "Install asdf"
#   if [ ! -e ~/.asdf ]; then
#     git clone https://github.com/asdf-vm/asdf.git ~/.asdf \
#       --branch v${INSTALL_ASDF_VERSION}
#   fi
#   if [ -z "$ASDF_DIR" ] ; then
#     source "$HOME/.asdf/asdf.sh"
#     source "$HOME/.asdf/completions/asdf.bash"

#   fi
#   asdf plugin add python
#   asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
#   asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
#   asdf plugin add rust https://github.com/code-lever/asdf-rust.git
# fi


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
    cargo install cargo-expand
  fi
fi

# Python - Pyenv
if [ -n "${ENABLE_PYTHON}" ]; then
  echo "Install pyenv"
  if [ ! -e ~/.pyenv ]; then
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv
  fi
  if [ ! -e ~/.pyenv/plugins/pyenv-virtualenv ]; then
    git clone https://github.com/yyuu/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv
  fi
  if [ ! -e ~/.pyenv/plugins/pyenv-update ]; then
    git clone https://github.com/pyenv/pyenv-update.git ~/.pyenv/plugins/pyenv-update
  fi

  if [ -z "$PYENV_SHELL" ] ; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    if command -v pyenv 1>/dev/null 2>&1; then
      eval "$(pyenv init -)"
      eval "$(pyenv virtualenv-init -)"
    fi
  fi
  pyenv install --skip-existing ${INSTALL_PYTHON_VERSION}
  pyenv global ${INSTALL_PYTHON_VERSION}
  pyenv rehash

  # install pipx (each cli-command's environment manager)
  if [ ! -e ~/.local/bin/pipx ]; then
    python3 -m pip install --user pipx
    python3 -m pipx ensurepath
  fi

  # install Poetry
  if [ ! -e ~/.local/bin/poetry ]; then
    # curl -sSL https://install.python-poetry.org | python3 -
    pipx install poetry
  fi
  if [ ! -e ~/.bash_completion.d/poetry.bash ]; then
    poetry completions bash > ~/.bash_completion.d/poetry.bash
    chmod +x ~/.bash_completion.d/poetry.bash
  fi
fi

# Ruby - rbenv
if [ -n "${ENABLE_RUBY}" ]; then
  echo "Install rbenv"
  if [ ! -e ~/.rbenv ]; then
    git clone https://github.com/rbenv/rbenv.git ~/.rbenv
  fi
  if [ ! -e ~/.rbenv/plugins/rbenv-update ]; then
    git clone https://github.com/rkh/rbenv-update.git ~/.rbenv/plugins/rbenv-update
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
  if [ ! -e ~/.nodenv/plugins/nodenv-update ]; then
    git clone https://github.com/nodenv/nodenv-update.git ~/.nodenv/plugins/nodenv-update
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
  npm install --global npm-check-updates
  nodenv rehash
fi


# Go
if [ -n "${ENABLE_GO}" ]; then
  echo "Install Go"
  if [ ! -e ~/.goenv ]; then
    git clone https://github.com/syndbg/goenv.git ~/.goenv
  fi

  if [ -z "$GOENV_ROOT" ]; then
    export GOENV_ROOT="$HOME/.goenv"
    export PATH="$GOENV_ROOT/bin:$PATH"
    if command -v goenv 1>/dev/null 2>&1; then
      eval "$(goenv init -)"
    fi
    export PATH="$GOROOT/bin:$PATH"
    export PATH="$PATH:$GOPATH/bin"
  fi
  goenv install --skip-existing $INSTALL_GO_VERSION
  goenv global $INSTALL_GO_VERSION
  goenv rehash
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
