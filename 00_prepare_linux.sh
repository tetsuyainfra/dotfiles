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
if [ ${ISWSL} -eq 2 ]; then
  wsl2_ssh_agent_bin="$HOME/.ssh/wsl2-ssh-agent"
  if [ ! -f "${wsl2_ssh_agent_bin}" ]; then
    curl -L -o ${wsl2_ssh_agent_bin} https://github.com/mame/wsl2-ssh-agent/releases/latest/download/wsl2-ssh-agent
    chmod 755 ${wsl2_ssh_agent_bin}
  fi
fi


