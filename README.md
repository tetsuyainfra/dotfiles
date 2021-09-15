
# dotfile.git

[tetsuyainfra/dotfile.git](https://github.com/tetsuyainfra/dotfile.git)

# how to use: WSL(Ubuntu)
```
# set repository url from https to git.
./setup/modify_git_remote_repo_url.sh

# install conf
./setup.sh

# install environment
## install all package
ENABLE_ALL=1 ./install_ubuntu.sh

```




# Bash
- Ubuntu環境では .bash_aliases にリンクを張っておけば
  bashrcの書き換えなどをしなくて済む