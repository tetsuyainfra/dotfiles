
# update
#if test -e $HOME/.rbenv
#	status --is-interactive; and pushd $HOME/.rbenv; and git pull --verbose; and popd
#end

#if test -e $HOME/.rbenv/plugins/ruby-build
#	status --is-interactive; and pushd $HOME/.rbenv/plugins/ruby-build; and git pull --verbose; and popd
#end

# setup
if test -e $HOME/.pyenv/bin
	set -x PYENV_ROOT $HOME/.pyenv
	set -x PATH $PYENV_ROOT/bin   $PATH
end

if which pybnv > /dev/null 2>&1
	status --is-interactive; and source (pyenv init - | psub)
end
