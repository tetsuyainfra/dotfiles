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

- dotter でファイルの管理をする
  - dotter, dotter.exe バイナリを含める(dotfiles ディレクトリ内で直接実行するので bin/には含めない)
- OS の違いは prepare\_{windows.bat|unix.sh}で吸収する
  - バッチファイル内で.dotter/local.toml を OS 毎のスケルトンをコピーする
- prepare\_\* は 設定ファイルのコピー/リンク
- setup\_\* は基本ソフトウェアのインストール

# Bash

- Ubuntu 環境では .bash_aliases にリンクを張っておけば
  bashrc の書き換えなどをしなくて済む

# 便利そう

- https://speakerdeck.com/hsbt/kai-fa-huan-jing-hefalsekodawari?slide=8
  find -> fdfind
  grep -> ripgrep(rg)
  sed -> sd
  cat -> bat
  dig -> dog carate.io に登録されてない
  man -> tealdeer(tldr)
