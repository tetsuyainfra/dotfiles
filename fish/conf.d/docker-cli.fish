
# setup
if which cmd.exe > /dev/null 2>&1 ; and which docker > /dev/null 2>&1;
	set -x DOCKER_HOST "tcp://0.0.0.0:2375"
end
