mastodon_app_systemd
====================

Mastodon の systemd ユニットファイルをアプリリポジトリの `dist/` ディレクトリから
`/etc/systemd/system/` へコピーする。

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
| `mastodon_sys_copyfiles` | 下記参照 | コピーするファイルの `src`/`dest` リスト |

`mastodon_sys_copyfiles` のデフォルト値:

```yaml
mastodon_sys_copyfiles:
  - src: "{{ mastodon_app_path }}/dist/mastodon-web.service"
    dest: /etc/systemd/system/
  - src: "{{ mastodon_app_path }}/dist/mastodon-sidekiq.service"
    dest: /etc/systemd/system/
```

生成ファイル・ディレクトリ
--------------------------

| パス | 内容 |
|------|------|
| `/etc/systemd/system/mastodon-web.service` | Mastodon Web (Puma) サービスユニット |
| `/etc/systemd/system/mastodon-sidekiq.service` | Mastodon Sidekiq サービスユニット |

systemd / nginx / postgresql への影響
--------------------------------------

- `mastodon-web.service` と `mastodon-sidekiq.service` を `/etc/systemd/system/` に登録する。
- このロールはサービスの **enable / start を行わない**。ファイルコピー後に `systemctl daemon-reload` が必要。
- 初回インストール後に `systemctl enable --now mastodon-web mastodon-sidekiq` を手動または別タスクで実行すること。

再実行時の挙動 (冪等性)
------------------------

- **copy_config.yml**: `copy` モジュール (`remote_src: true`) を使用。
  コピー先ファイルの内容が同一であれば `ok`、差異があれば `changed` を返す。
  上書きは常に実行されるが、ファイル内容が変わらない限り実際の変更は発生しない。

使用 tags
---------

なし。

Requirements
------------

- `mastodon_app_repository` ロールで Mastodon リポジトリがクローン済みであること (`dist/*.service` が存在すること)。
- コピー先への書き込みに `root` 権限が必要 (`become_user: root` を使用)。

Example Playbook
----------------

    - hosts: mastodon_servers
      roles:
        - role: mastodon_app_systemd

License
-------

BSD

Author Information
------------------

guskma
