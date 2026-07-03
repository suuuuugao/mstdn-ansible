mastodon_db_packages
====================

PostgreSQL 公式 APT リポジトリ (PGDG) を追加し、PostgreSQL 15 と
Mastodon が必要とするビルド依存パッケージをインストールする。

対応 OS
-------

- Ubuntu 22.04 LTS
- Ubuntu 24.04 LTS

(Incus システムコンテナ経由で Ansible 管理)

必要変数
--------

ユーザ設定変数なし。内部変数のみ (`vars/main.yml`):

| 変数名 | 値 | 説明 |
|--------|----|------|
| `__mastodon_db_aptkey_url` | `https://www.postgresql.org/media/keys/ACCC4CF8.asc` | PostgreSQL 署名キー URL |
| `__mastodon_apt_db_packages` | (リスト参照) | インストールするパッケージ一覧 |

インストールされる主なパッケージ:
- `postgresql-15`
- `libpq-dev`
- `python3-psycopg2`
- `libxml2-dev`, `libxslt1-dev`
- `libprotobuf-dev`, `protobuf-compiler`
- `pkg-config`, `autoconf`, `bison`
- `libidn11-dev`, `libicu-dev`

生成ファイル・ディレクトリ
--------------------------

| パス | 内容 |
|------|------|
| `/etc/apt/trusted.gpg.d/` | PostgreSQL 署名キーを追加 |
| `/etc/apt/sources.list.d/postgresql.list` | PGDG リポジトリエントリ |

systemd / nginx / postgresql への影響
--------------------------------------

- `postgresql-15` パッケージのインストールにより PostgreSQL サービスが自動起動する (Debian/Ubuntu 標準動作)。
- `mastodon_db_user` ロールで PostgreSQL ユーザを作成する前にこのロールを先に実行すること。

再実行時の挙動 (冪等性)
------------------------

- **add-apt-packages.yml**:
  - `apt_key`: キーが既に登録済みの場合は `ok`。
  - `apt_repository`: リポジトリが既に `/etc/apt/sources.list.d/postgresql.list` に存在する場合は `ok`。
  - `apt` モジュール: パッケージが既にインストール済みの場合は `ok`。

使用 tags
---------

なし。

Requirements
------------

- `mastodon_sys_packages` ロールで APT キャッシュが更新済みであること。
- ターゲットホストからインターネット (`apt.postgresql.org`) へのアクセスが可能であること。

Example Playbook
----------------

    - hosts: mastodon_servers
      roles:
        - role: mastodon_db_packages

License
-------

BSD

Author Information
------------------

guskma
