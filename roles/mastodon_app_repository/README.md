mastodon_app_repository
=======================

Mastodon アプリのリポジトリを GitHub からクローンする。
`mastodon` OS ユーザとして実行し、指定バージョン (タグ / コミット) をチェックアウトする。

対応 OS
-------

- Ubuntu 22.04 LTS
- Ubuntu 24.04 LTS

(Incus システムコンテナ経由で Ansible 管理)

必要変数
--------

| 変数名 | デフォルト値 | 説明 |
|--------|-------------|------|
| `mastodon_app_version` | **(必須、デフォルトなし)** | チェックアウトするバージョン (例: `v4.3.2`) |
| `mastodon_app_user_name` | `mastodon` | クローンを実行する OS ユーザ名 |
| `mastodon_app_path` | `/home/mastodon/live` | クローン先ディレクトリ |
| `mastodon_app_repository` | `https://github.com/mastodon/mastodon.git` | クローン元 URL |

生成ファイル・ディレクトリ
--------------------------

| パス | 内容 |
|------|------|
| `{{ mastodon_app_path }}/` | Mastodon ソースツリー全体 |

systemd / nginx / postgresql への影響
--------------------------------------

影響なし。

再実行時の挙動 (冪等性)
------------------------

- **mastodon-repository.yml**: 事前チェックで `mastodon` OS ユーザの存在を確認する (`check_mode: true`)。
  `git` モジュールは毎回 `git fetch` を実行し、指定 `version` が既にチェックアウト済みなら `ok`、
  差異があれば `changed` を返す。

使用 tags
---------

なし。

Requirements
------------

- `mastodon_app_user` ロールで `mastodon` OS ユーザが作成済みであること。
- ターゲットホストからインターネット (github.com) へのアクセスが可能であること。

Example Playbook
----------------

    - hosts: mastodon_servers
      roles:
        - role: mastodon_app_repository
          vars:
            mastodon_app_version: "v4.3.2"

License
-------

BSD

Author Information
------------------

guskma
