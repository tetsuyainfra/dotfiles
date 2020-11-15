#!/bin/bash
DOT_ANSIBLE_DIR=$(cd $(dirname $0); pwd)

set -ex
echo $DOT_ANSIBLE_DIR

pushd $DOT_ANSIBLE_DIR
  if [ ! -e "vars/dot_vars.yml" ] ; then
    exit
  fi

  ansible-playbook -i inventories/local --ask-become-pass play_env_dev.yml
popd
