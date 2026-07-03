mastodon_app_anyenv
===================

anyenv を使って Ruby (rbenv) と Node.js (nodenv) の実行環境を構築する。
指定バージョンの Ruby・Node.js をインストールし、bundler と yarn (classic) をセットアップする。

対応 OS
-------

- Ubuntu 22.04 LTS
- Ubuntu 24.04 LTS

(Incus システムコンテナ経由で Ansible 管理)

必要変数
--------

| 変数名 | デフォルト値 | 説明 |
|--------|-------------|------|
| `mastodon_app_path` | `/home/mastodon/live` | Mastodon アプリルートディレクトリ |
| `mastodon_app_anyenv_path` | `/home/mastodon/.anyenv` | anyenv インストール先 |
| `mastodon_app_user_name` | `mastodon` | アプリ実行 OS ユーザ名 |
| `mastodon_app_shell_profile` | `/home/mastodon/.bash_profile` | anyenv PATH 設定を追記するシェルプロファイル |
| `mastodon_node_version` | `22.11.0` | インストールする Node.js バージョン (固定推奨) |
| `mastodon_ruby_version` | `3.3.4` | インストールする Ruby バージョン (固定推奨) |

生成ファイル・ディレクトリ
--------------------------

| パス | 内容 |
|------|------|
| `~mastodon/.anyenv/` | anyenv 本体 (git clone) |
| `~mastodon/.anyenv/envs/rbenv/` | rbenv 本体 |
| `~mastodon/.anyenv/envs/nodenv/` | nodenv 本体 |
| `~mastodon/.bash_profile` | anyenv PATH / init 設定を追記 |
| `~mastodon/.anyenv/envs/rbenv/versions/<ruby>/` | Ruby インストール先 |
| `~mastodon/.anyenv/envs/nodenv/versions/<node>/` | Node.js インストール先 |

systemd / nginx / postgresql への影響
--------------------------------------

影響なし。

再実行時の挙動 (冪等性)
------------------------

- **anyenv.yml**: anyenv が既にクローン済みなら `git` タスクは `ok`。
  `anyenv install --update` は `Fast-forward` が stdout に含まれる場合のみ `changed`。
  初回 init (`--init`) は `~/.config/anyenv/anyenv-install` が存在しない場合のみ実行。
- **nodenv.yml**: `nodenv install -s` は既インストール済みならスキップ (`-s` フラグ)。
  `nodenv global` は常に実行されるが、バージョンが一致していれば実質 no-op。
  yarn インストールは `added 1 package` / `updated 1 package` が stdout に含まれる場合のみ `changed`。
- **rbenv.yml**: `rbenv install -s` は既インストール済みならスキップ。
  bundler の `gem install` は `Fetching bundler` / `Successfully installed bundler` が stdout に含まれる場合のみ `changed`。

使用 tags
---------

なし。

Requirements
------------

- `mastodon_app_user` ロールで `mastodon` OS ユーザが作成済みであること。
- apt パッケージ `python3-pexpect` と `libatomic1` はこのロールが自動インストールする。
- Ruby ビルドには `g++`, `gcc`, `build-essential` 等が必要 (`rbenv.yml` で自動インストール)。

Example Playbook
----------------

    - hosts: mastodon_servers
      roles:
        - role: mastodon_app_anyenv
          vars:
            mastodon_node_version: "22.11.0"
            mastodon_ruby_version: "3.3.4"

License
-------

BSD

Author Information
------------------

guskma
