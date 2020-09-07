#!/bin/bash

set -ex

if [ ! -e "vars/dot_vars.yml" ] ; then
  ansible-playbook -i inventories/local playbooks/init_vars.yml
fi

ansible-playbook -i inventories/local setup.yml
