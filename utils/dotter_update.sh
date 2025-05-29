#!/usr/bin/env bash
DOT_DIR=$(cd $(dirname $0); cd ../ ; pwd)

set -ex

function download_gh_release() {
  echo Download $2 from github: $1
  curl -sLO $(curl -s https://api.github.com/repos/$1/releases/latest | jq -r '.assets[] | select(.name | startswith("'"$2"'")) | .browser_download_url')
}


pushd $DOT_DIR
  download_gh_release SuperCuber/dotter dotter-linux-x64-musl
  mv ./dotter-linux-x64-musl ./dotter
popd