mastodon_db_user
================

PostgreSQL に Mastodon 用ロール (`mastodon`) を作成し、CREATEDB 権限を付与する。
実行前に PostgreSQL 15 パッケージと `postgres` OS ユーザの存在を確認するプリフライトチェックを行う。

対応 OS
-------

- Ubuntu 22.04 LTS
- Ubuntu 24.04 LTS

(Incus システムコンテナ経由で Ansible 管理)

必要変数
--------

| 変数名 | デフォルト値 | 説明 |
|--------|-------------|------|
| `mastodon_db_user_name` | `mastodon` | 作成する PostgreSQL ロール名 |
| `mastodon_db_user_password` | `{{ lookup('ansible.builtin.pipe', '/usr/bin/uuidgen') }}` | PostgreSQL ロールのパスワード (実行ごとに UUID が自動生成される) |

> **注意**: デフォルトのパスワード生成は実行のたびに異なる UUID を生成する。
> `mastodon_app_config` ロールの `mastodon_pg_password` と一致させるため、
> `group_vars` で明示的に固定することを強く推奨する。

生成ファイル・ディレクトリ
--------------------------

なし (PostgreSQL クラスタ内にロールを作成するのみ)。

systemd / nginx / postgresql への影響
--------------------------------------

- PostgreSQL クラスタの `pg_roles` に `mastodon` ロールを追加する。
- `become_user: postgres` で実行するため、PostgreSQL サービスが起動済みである必要がある。

再実行時の挙動 (冪等性)
------------------------

- **check-pre.yml**:
  - `apt` モジュール (check_mode): `postgresql-15` が未インストールの場合はここで失敗して停止する。
  - `user` モジュール (check_mode): `postgres` OS ユーザが存在しない場合はここで失敗して停止する。
- **add-pg-user.yml**:
  - `postgresql_user` モジュール: ロールが既に存在する場合はパスワードと属性を更新する。
    デフォルトのパスワードが毎回変わるため、`mastodon_db_user_password` を固定しない限り毎回 `changed` になる。
  - `debug` タスクでパスワードを表示する (本番運用では `no_log: true` 追加を推奨)。

使用 tags
---------

なし。

Requirements
------------

- `mastodon_db_packages` ロールで `postgresql-15` がインストール済みであること。
- `community.postgresql` コレクションがコントロールノードにインストール済みであること (`ansible-galaxy collection install community.postgresql`)。

Example Playbook
----------------

    - hosts: mastodon_servers
      roles:
        - role: mastodon_db_user
          vars:
            mastodon_db_user_name: mastodon
            mastodon_db_user_password: "{{ vault_db_password }}"

License
-------

BSD

Author Information
------------------

guskma
