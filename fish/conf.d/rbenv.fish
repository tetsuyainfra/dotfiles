
if which rbenv > /dev/null
#	rbenv init - | source
	status --is-interactive; and source (rbenv init -|psub)
end
