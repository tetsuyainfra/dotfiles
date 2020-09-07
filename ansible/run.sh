#!/bin/bash
DOT_ANSIBLE_DIR=$(cd $(dirname $0); pwd)

set -ex
echo $DOT_ANSIBLE_DIR

pushd $DOT_ANSIBLE_DIR
  if [ ! -e "vars/dot_vars.yml" ] ; then
    ansible-playbook -i inventories/local playbooks/init_vars.yml
  fi

  ansible-playbook -i inventories/local setup.yml
popd