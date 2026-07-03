mastodon_app_packages
=====================

Mastodon アプリに必要な Ruby gems (bundler 経由) と Node.js パッケージ (yarn 経由) をインストールする。
オプションで `node_modules` / `vendor/bundle` を削除して強制再インストールする cleanup も含む。

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
| `mastodon_app_environment` | `production` | Rails 環境 |
| `mastodon_force_reinstall_dependencies` | `false` | `true` にすると `node_modules` / `vendor/bundle` を削除してから再インストール |

生成ファイル・ディレクトリ
--------------------------

| パス | 内容 |
|------|------|
| `{{ mastodon_app_path }}/vendor/bundle/` | Ruby gems (bundler deployment モード) |
| `{{ mastodon_app_path }}/node_modules/` | Node.js パッケージ (yarn) |

systemd / nginx / postgresql への影響
--------------------------------------

影響なし。

再実行時の挙動 (冪等性)
------------------------

- **cleanup.yml**: `mastodon_force_reinstall_dependencies: false` (デフォルト) の場合はスキップ。
  `true` にした場合のみ `node_modules` / `vendor/bundle` を削除する破壊的操作が実行される。
- **install_ruby_packages.yml**: `bundle install` は常に実行されるが `changed_when: false` のため常に `ok` を返す。
  実際のインストール差分はログで確認する。
- **install_node_packages.yml**: `yarn install` の stdout に `Done` が含まれる場合のみ `changed`。
  `failed_when: false` で yarn のエラーを抑制している点に注意 (エラーはログ確認が必要)。

使用 tags
---------

なし。

Requirements
------------

- `mastodon_app_repository` ロールで Mastodon リポジトリがクローン済みであること。
- `mastodon_app_anyenv` ロールで rbenv / nodenv / bundler / yarn が利用可能であること。

Example Playbook
----------------

    - hosts: mastodon_servers
      roles:
        - role: mastodon_app_packages

    # 強制再インストールが必要な場合:
    - hosts: mastodon_servers
      roles:
        - role: mastodon_app_packages
          vars:
            mastodon_force_reinstall_dependencies: true

License
-------

BSD

Author Information
------------------

guskma
