# fish/config.fish

#
umask 002

# dotfiles bin folder
if [ -e $HOME/dotfiles/bin ];
  set PATH $HOME/dotfiles/bin $PATH
end

# cheat sheet
function cheat.sh
    curl cheat.sh/$argv
end
# register completions (on-the-fly, non-cached, because the actual command won't be cached anyway
complete -c cheat.sh -xa '(curl -s cheat.sh/:list)'

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/tetsuya/google-cloud-sdk/path.fish.inc' ]; . '/home/tetsuya/google-cloud-sdk/path.fish.inc'; end
