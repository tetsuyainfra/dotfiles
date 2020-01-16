
if test -e /home/linuxbrew/.linuxbrew/bin/brew
  #  eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
  #set -x PYENV_ROOT $HOME/.pyenv
  #set -x PATH $PYENV_ROOT/bin   $PATH
  #set -x PATH $PYENV_ROOT/shims $PATH
  set -x HOMEBREW_PREFIX     /home/linuxbrew/.linuxbrew
  set -x HOMEBREW_CELLAR     /home/linuxbrew/.linuxbrew/Cellar
  set -x HOMEBREW_REPOSITORY /home/linuxbrew/.linuxbrew/Homebrew
  set -x PATH      /home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin $PATH
  set -x MANPATH   /home/linuxbrew/.linuxbrew/share/man  $MANPATH
  set -x INFOPATH  /home/linuxbrew/.linuxbrew/share/info $INFOPATH
end

#if which pybnv > /dev/null 2>&1
#	status --is-interactive; and source (pyenv init - | psub)
#end
