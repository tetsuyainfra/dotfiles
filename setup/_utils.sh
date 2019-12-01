#!/usr/bin/env bash

function dotdir() {
  echo "$(cd $(dirname $0); cd ../; pwd)"
}

DOT_DIR=`dotdir`
echo "DOT_DIR: ${DOT_DIR}"
