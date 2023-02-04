# dotfile.git

[tetsuyainfra/dotfile.git](https://github.com/tetsuyainfra/dotfile.git)

## how to use: Ubuntu@WSL2

```
# set repository url from https to git.
./setup/modify_git_remote_repo_url.sh

# create symbolic link for dotter local settings
ln -s skel/local_ubuntu.toml .dotter/local.toml

# prepare conf & execute dotter in script
./prepare_linux.sh

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

# Rust 開発環境

- Rust のバージョンは rustup で管理する

# Python 開発環境

- Python のバージョンは pyenv で管理する
- CLI は pipx で管理する(pipx はコマンド毎に venv を作ってくれる)
- 各ソフトウェアでパッケージ管理は poetry を使う
  - poetry のプラグイン管理は pipx コマンドを使わないと行けないのを忘れないこと(詳細は公式サイトの Plugins ドキュメントを参照)
- poetry は環境毎に venv を作るが、パッケージに含まれるコマンドは PATH に入らない。
  - これを有効にするには`poetry shell`を入力しなくてはならない。
  - 毎回入力するのは面倒なので direnv を使うこれは`echo layout poetry > .envrc`が必要
    - 詳細 https://github.com/direnv/direnv/wiki/Python#poetry

# Ruby 開発環境

- Ruby のバージョンは rbenv で管理する
- v 3.2.0 から yjit が有効になった。これは Rust に依存するので Ruby を入れると Rust も入る

# Node 開発環境

- Node のバージョンは nodenv で管理する
