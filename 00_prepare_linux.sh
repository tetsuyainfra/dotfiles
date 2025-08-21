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

if [ ! -e ${DOT_DIR}/local_bin/mise ]; then
  checksum="fd7ad2e877900134dc8e5317a5081f595a77837fc31cd22c905eade95bcafd55"
  curl -L --output ${DOT_DIR}/local_bin/mise.tar.gz \
    https://github.com/jdx/mise/releases/download/v2025.8.13/mise-v2025.8.13-linux-x64.tar.gz
  pushd local_bin
  if echo "${checksum} mise.tar.gz" | sha256sum -c > /dev/null ; then
    tar zxfv mise.tar.gz --strip-components=2 mise/bin/mise
    chmod +x mise
  else
    echo "Download mise failed"
  fi
  rm -f mise.tar.gz
  popd
fi

## dotter
pushd ${DOT_DIR}

set +e
./dotter

if [ "$?" -ne 0 ]; then
  set +x
  echo "dotter failed"
  echo "Please check the output above for errors."
  echo "if you forget to set git_username, email. please write this to ${DOTTER_LOCAL_FILE}"
  exit 1
fi
set -e
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
  WSL_SSH_AGENT_VER="v0.9.6"
  WSL_SSH_AGENT_SHA256="0d080edabe300ef94f858f1a937188eccd96115e875fb22da3c54479cbd57207"
  wsl2_ssh_agent_bin="$HOME/.ssh/wsl2-ssh-agent"
  if [ ! -f "${wsl2_ssh_agent_bin}" ]; then
    curl -L -o ${wsl2_ssh_agent_bin} "https://github.com/mame/wsl2-ssh-agent/releases/download/${WSL_SSH_AGENT_VER}/wsl2-ssh-agent"
    sha256sum -c <<< "${WSL_SSH_AGENT_SHA256}  ${wsl2_ssh_agent_bin}"
    if [ $? -ne 0 ]; then
      echo "Checksum verification failed for ${wsl2_ssh_agent_bin}"
      rm -f ${wsl2_ssh_agent_bin}
      exit 1
    fi
    chmod 755 ${wsl2_ssh_agent_bin}
  fi
fi


