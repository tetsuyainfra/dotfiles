
# dotfile.git

[tetsuyainfra/dotfile.git](https://github.com/tetsuyainfra/dotfile.git)

## how to use: Ubuntu@WSL2
```
# set repository url from https to git.
./setup/modify_git_remote_repo_url.sh

# install conf
./setup.sh

# install environment
## install all package
ENABLE_ALL=1 ./install_ubuntu.sh

```

## how to use: CommandLine(Windows)
```
# set repository url from https to git.
./setup/modify_git_remote_repo_url.bat

# install conf
./prepare_windows.bat



```


# 仕組みのメモ
- dotterでファイルの管理をする
  - bin/dotter, bin/dotter.exeを含める
- OSの違いはprepare_{windows.bat|unix.sh}で吸収する
  - バッチファイル内で.dotter/local.tomlをOS毎のスケルトンをコピーする
- prepare_* は 設定ファイルのコピー/リンク
- setup_* は基本ソフトウェアのインストール


# Bash
- Ubuntu環境では .bash_aliases にリンクを張っておけば
  bashrcの書き換えなどをしなくて済む


# 便利そう
- https://speakerdeck.com/hsbt/kai-fa-huan-jing-hefalsekodawari?slide=8
find -> fdfind
grep -> ripgrep(rg)
sed -> sd
cat -> bat
dig -> dog carate.ioに登録されてない
man -> tealdeer(tldr)
