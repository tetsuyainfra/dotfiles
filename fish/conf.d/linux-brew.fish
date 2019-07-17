
if test -e /home/linuxbrew/.linuxbrew/bin/brew
  eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
	#set -x PYENV_ROOT $HOME/.pyenv
	#set -x PATH $PYENV_ROOT/bin   $PATH
	#set -x PATH $PYENV_ROOT/shims $PATH
end

#if which pybnv > /dev/null 2>&1
#	status --is-interactive; and source (pyenv init - | psub)
#end