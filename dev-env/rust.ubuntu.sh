!/bin/sh
set -x

DOT_DIR=$(cd $(dirname $0);pwd)
echo "DOT_DIR: $DOT_DIR"

## Rust
# if !(which cargo >/dev/null 2>&1) ; then
if !(test -e $HOME/.cargo/bin) ; then
  curl https://sh.rustup.rs -sSf | sh
fi
