
# setup
if which X > /dev/null 2>&1 ; 
	set -x EDITOR vim
	set -x DISPLAY :0.0
	set -x LIBGL_ALWAYS_INDIRECT 1
end
