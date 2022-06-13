


## ファイルパスの確認
git config --list --show-origin --show-scope

### Windows(~/.gitconfigのみ)
```
...
system  file:C:/Program Files/Git/etc/gitconfig init.defaultbranch=master
global  file:C:/Users/admin/.gitconfig  user.name=tetsuyainfra
local   file:.git/config        core.repositoryformatversion=0
...
```

### Windows(~/.config/git, ~/.gitconfigが存在)
最終的に.gitconfigの値で上書されると思われる
```
global  file:"C:\\Users\\admin/.config/git/config"      credential.helper=cache
global  file:C:/Users/admin/.gitconfig  user.name=tetsuyainfra
local   file:.git/config        core.repositoryformatversion=0
```