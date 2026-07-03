# mastodon_restore

mastodon_backup ロールで取得したバックアップから Mastodon を復元するロール。

## 目的

タイムスタンプ付きバックアップディレクトリから以下を復元する:

- PostgreSQL database (`pg_restore`)
- `.env.production`
- `public/system/`（メディアファイル）
- nginx 設定
- systemd unit ファイル

**★★★ 破壊的操作はすべて `mastodon_restore_confirm: true` でガード ★★★**

デフォルトは `false`。このフラグが `true` でない限り、いかなる上書きも実行しない。

## 変数

| 変数名 | デフォルト | 説明 |
|--------|-----------|------|
| `mastodon_restore_confirm` | `false` | **必須: true にしないと一切の復元操作が走らない** |
| `mastodon_restore_backup_dir` | `/home/mastodon/backups` | バックアップルートディレクトリ |
| `mastodon_restore_backup_timestamp` | `""` | 復元元バックアップのサブディレクトリ名（必須） |
| `mastodon_restore_target_db` | `mastodon_production` | 復元先 DB 名 |
| `mastodon_restore_db_user` | `mastodon` | pg_restore 実行ユーザ |
| `mastodon_restore_app_path` | `/home/mastodon/live` | Mastodon アプリケーションパス |
| `mastodon_restore_nginx_conf_dir` | `/etc/nginx/sites-available` | nginx 設定ディレクトリ |
| `mastodon_restore_systemd_dir` | `/etc/systemd/system` | systemd unit ディレクトリ |

## 使い方

```bash
# mastodon_restore_confirm=true を明示的に渡さないと何も起きない
ansible-playbook -i inventory.yml restore.yml \
  -e mastodon_restore_confirm=true \
  -e mastodon_restore_backup_timestamp=20260703T120000
```

```yaml
# playbook での指定例
- hosts: mastodon_servers
  roles:
    - role: mastodon_restore
      vars:
        mastodon_restore_confirm: true
        mastodon_restore_backup_timestamp: "20260703T120000"
```

## 注意事項

- `mastodon_restore_confirm: false`（デフォルト）では assert で即停止する
- `mastodon_restore_backup_timestamp` が空の場合も assert で停止する
- 復元前に mastodon-web/sidekiq/streaming を停止し、復元後に再起動する
- `become: true` が必要
- このロールは playbook への配線を含まない（ロール単体完結）
