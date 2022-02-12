#!/usr/bin/env bash
DOT_DIR=$(cd $(dirname $0); cd ../ ; pwd)

set -e

if [ ${EUID:-${UID}} != 0 ]; then
  echo "USAGE: sudo $0"
  exit 1
fi

set -x

sed -i.bak -e s!http://archive.ubuntu.com/ubuntu/!mirror://mirrors.ubuntu.com/mirrors.txt! /etc/apt/sources.list
