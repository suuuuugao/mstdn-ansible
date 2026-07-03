mastodon_sys_packages
=====================

システム全体の apt パッケージを更新 (`apt full-upgrade`) し、
他のロールが必要とする共通システムパッケージをインストールする。
Mastodon セットアップの最初に実行することを想定している。

対応 OS
-------

- Ubuntu 22.04 LTS
- Ubuntu 24.04 LTS

(Incus システムコンテナ経由で Ansible 管理)

必要変数
--------

ユーザ設定変数なし。内部変数のみ (`vars/main.yml`):

| 変数名 | 説明 |
|--------|------|
| `__mastodon_apt_packages` | インストールする共通パッケージ一覧 |

インストールされるパッケージ:
- `curl`
- `wget`
- `gnupg`
- `apt-transport-https`
- `lsb-release`
- `ca-certificates`
- `acl`

生成ファイル・ディレクトリ
--------------------------

なし (システムパッケージの状態変更のみ)。

systemd / nginx / postgresql への影響
--------------------------------------

- `apt full-upgrade` はカーネルや libc のアップグレードを含む場合がある。
  その場合は Debian/Ubuntu の標準動作として関連サービスが再起動されることがある。

再実行時の挙動 (冪等性)
------------------------

- **upgrade_apt_packages.yml**:
  - `apt` (upgrade: full): 毎回実行される。アップグレード対象パッケージがある場合は `changed`、なければ `ok`。
  - `apt` (共通パッケージ): 全パッケージがインストール済みであれば `ok`。

使用 tags
---------

なし。

Requirements
------------

なし (他ロールへの依存なし)。
ただしインターネットアクセスが必要 (APT リポジトリへの接続)。

Example Playbook
----------------

    - hosts: mastodon_servers
      roles:
        - role: mastodon_sys_packages

License
-------

BSD

Author Information
------------------

guskma
