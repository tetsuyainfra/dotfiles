#!/bin/bash

# statuscode != 0 must shutdown script SOON
set -e

# if variable is undefined, shutdown script
set -u

# visible command
#set -v

# Show debug info
set -x

apt install x11-apps x11-utils x11-xserver-utils fonts-ipafont \
              gnuplot gnuplot-x11

if [ ! -e /usr/share/fonts/windows ] ; then
  ln -s /mnt/c/Windows/Fonts /usr/share/fonts/windows
  fc-cache -fv
fi