#!/usr/bin/env bash
set -ex

git remote -v

git remote set-url origin git@github.com:tetsuyainfra/dotfiles.git https://github.com/tetsuyainfra/dotfiles.git


git remote -v