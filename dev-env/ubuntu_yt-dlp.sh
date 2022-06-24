#!/bin/sh
set -x

DOT_DIR=$(cd $(dirname $0);pwd)
echo "DOT_DIR: $DOT_DIR"

if ! $(type yt-dlp > /dev/null 2>&1); then
  curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o ~/.bin/yt-dlp
  chmod a+rx ~/.bin/yt-dlp
fi

