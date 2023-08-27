#!/usr/bin/env bash
set -ex
# detect what we have
if [  $(uname -a | grep -c "Microsoft") -eq 1 ]; then
    export ISWSL=1 # WSL 1
elif [ $(uname -a | grep -c "microsoft") -eq 1 ]; then
    export ISWSL=2 # WSL 2
else
    export ISWSL=0
fi

function dotdir() {
  echo "$(cd $(dirname $0); pwd)"
}
DOT_DIR=`dotdir`

DOTTER_LOCAL_FILE="${DOT_DIR}/.dotter/local.toml"
DOTTER_LOCAL_SKEL="${DOT_DIR}/.dotter/skel/local_ubuntu.toml"

if [ ! -e "${DOTTER_LOCAL_FILE}" ] ; then
cp ${DOTTER_LOCAL_SKEL} ${DOTTER_LOCAL_FILE}
fi


## dotter
pushd ${DOT_DIR}

./dotter

popd

## WSL2 support ssh
#if [ ${ISWSL} -eq 2 ]; then
#  windows_destination="/mnt/d/opt/bin/wsl2-ssh-pageant.exe"
#  linux_destination="$HOME/.ssh/wsl2-ssh-pageant.exe"
#  mkdir -p $HOME/.ssh
#  chmod +x "$windows_destination"
#  ln -s $windows_destination $linux_destination
#fi


