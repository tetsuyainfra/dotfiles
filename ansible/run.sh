#!/bin/bash
DOT_ANSIBLE_DIR=$(cd $(dirname $0); pwd)

set -ex
echo $DOT_ANSIBLE_DIR

pushd $DOT_ANSIBLE_DIR
  if [ ! -e "vars/dot_vars.yml" ] ; then
    ansible-playbook -i inventories/local playbooks/init_vars.yml
  fi

  # ansible-galaxy role install -p roles -r requirements.yml
  ansible-playbook -i inventories/local --ask-become-pass setup.yml
popd