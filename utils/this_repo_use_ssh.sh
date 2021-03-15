#!/usr/bin/env bash
DOT_DIR=$(cd $(dirname $0); cd ../ ; pwd)

set -ex

pushd $DOT_DIR
git remote -v
git remote set-url origin git@github.com:tetsuyainfra/dotfiles.git
git remote -v
popd