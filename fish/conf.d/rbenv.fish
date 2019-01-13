
# update
#if test -e $HOME/.rbenv
#	status --is-interactive; and pushd $HOME/.rbenv; and git pull --verbose; and popd
#end

#if test -e $HOME/.rbenv/plugins/ruby-build
#	status --is-interactive; and pushd $HOME/.rbenv/plugins/ruby-build; and git pull --verbose; and popd
#end

# setup
if test -e $HOME/.rbenv/bin 
	set -x PATH $HOME/.rbenv/bin   $PATH
	set -x PATH $HOME/.rbenv/shims $PATH
end

if which rbenv > /dev/null 2>&1
	status --is-interactive; and source (rbenv init -|psub)
end
