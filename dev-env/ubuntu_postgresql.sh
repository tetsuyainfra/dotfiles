#!/bin/sh
set -x

DOT_DIR=$(cd $(dirname $0);pwd)
echo "DOT_DIR: $DOT_DIR"

## Postgresql
apt install -y curl
sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
sudo apt update

# lib only
apt install -y libpq-dev postgresql-client
# apt install -y libpq-dev postgresql-client-11


### .config


