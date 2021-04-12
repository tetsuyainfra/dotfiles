#!/bin/bash

function dotdir() {
  echo "$(cd $(dirname $0); pwd)"
}
TARGET_DIR=`dotdir`/bash_completion.d

echo "TARGET_DIR: ${TARGET_DIR}"

curl \
    -L https://raw.githubusercontent.com/docker/compose/1.29.0/contrib/completion/bash/docker-compose \
    -o ${TARGET_DIR}/docker-compose.bash