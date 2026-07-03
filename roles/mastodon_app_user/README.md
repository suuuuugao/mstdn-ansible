mastodon_app_user
=================

Mastodon アプリを実行する OS ユーザ (`mastodon`) を作成する。
UID 2000 でホームディレクトリを作成し、オプションでパスワードの設定と sudo グループへの追加を行う。

対応 OS
-------

- Ubuntu 22.04 LTS
- Ubuntu 24.04 LTS

(Incus システムコンテナ経由で Ansible 管理)

必要変数
--------

| 変数名 | デフォルト値 | 説明 |
|--------|-------------|------|
| `mastodon_app_user_name` | `mastodon` | 作成する OS ユーザ名 |
| `mastodon_app_user_password` | `` (空) | パスワード (空の場合はパスワードなしで作成) |
| `mastodon_app_user_is_admin` | `false` | `true` にすると `sudo` グループに追加 |

生成ファイル・ディレクトリ
--------------------------

| パス | 内容 |
|------|------|
| `/home/mastodon/` | mastodon ユーザのホームディレクトリ (mode: `0755`) |

systemd / nginx / postgresql への影響
--------------------------------------

影響なし。

再実行時の挙動 (冪等性)
------------------------

- **add-app-user.yml**:
  - `user` モジュール: ユーザが既存の場合は `ok`。UID 2000 は初回作成時のみ割り当てられる。
  - `file` モジュール: ホームディレクトリのパーミッション確認は常に実行され、差異があれば `changed`。
  - パスワード設定タスク: `mastodon_app_user_password` が定義かつ空でない場合のみ実行。
  - sudo グループタスク: `mastodon_app_user_is_admin: true` の場合のみ実行。

使用 tags
---------

なし。

Requirements
------------

なし (他ロールへの依存なし)。

Example Playbook
----------------

    - hosts: mastodon_servers
      roles:
        - role: mastodon_app_user
          vars:
            mastodon_app_user_name: mastodon
            mastodon_app_user_is_admin: false

License
-------

BSD

Author Information
------------------

guskma
