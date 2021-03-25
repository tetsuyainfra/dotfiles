!/bin/sh
set -x

DOT_DIR=$(cd $(dirname $0);pwd)
echo "DOT_DIR: $DOT_DIR"

# if root or sudo will be exit !!
if [ "`whoami`" != "root" ]; then
  echo "you should exec root privilege"
  exit 1
fi


## Visual Studio Code
if ! $(type code > /dev/null 2>&1); then
	tmpfile=$(mktemp)
	trap "rm -f $tmpfile" EXIT 


	curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > $tmpfile
	install -o root -g root -m 644 $tmpfile /usr/share/keyrings/packages.microsoft.gpg
	sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

	apt-get install apt-transport-https
	apt-get update
	apt-get install code # or code-insiders
#	apt-get install code-insiders
fi

