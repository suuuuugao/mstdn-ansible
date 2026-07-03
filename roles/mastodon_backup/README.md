# mastodon_backup

Mastodon サーバのバックアップを取得するロール。

## 目的

以下を単一タイムスタンプ付きディレクトリへまとめてバックアップする:

- PostgreSQL dump (`pg_dump -Fc`)
- `.env.production`（暗号化キー含む最重要ファイル）
- `public/system/`（メディアファイル）
- nginx 設定 (`/etc/nginx/sites-available/`)
- systemd unit ファイル (`mastodon-*.service`)

## 変数

| 変数名 | デフォルト | 説明 |
|--------|-----------|------|
| `mastodon_backup_dir` | `/home/mastodon/backups` | バックアップ出力先ルート |
| `mastodon_backup_db_name` | `mastodon_production` | pg_dump 対象 DB 名 |
| `mastodon_backup_db_user` | `mastodon` | pg_dump 実行ユーザ |
| `mastodon_backup_timestamp` | `ansible_date_time.iso8601_basic_short` | バックアップサブディレクトリ名 |
| `mastodon_backup_app_path` | `/home/mastodon/live` | Mastodon アプリケーションパス |
| `mastodon_backup_nginx_conf_dir` | `/etc/nginx/sites-available` | nginx 設定ディレクトリ |
| `mastodon_backup_systemd_dir` | `/etc/systemd/system` | systemd unit ディレクトリ |

## 使い方

```yaml
- hosts: mastodon_servers
  roles:
    - mastodon_backup
```

変数を上書きする場合:

```yaml
- hosts: mastodon_servers
  roles:
    - role: mastodon_backup
      vars:
        mastodon_backup_dir: /mnt/external/backups
```

## 注意事項

- `become: true` が必要（postgres ユーザ・root 権限を使用）
- `pg_dump` は `postgres` ユーザではなく `mastodon_backup_db_user`（デフォルト: mastodon）で実行
- バックアップファイルはすべて mode 0600/0700 で保護される
- このロールは playbook への配線を含まない（ロール単体完結）
- playbook への組み込みは issue #8 を参照
