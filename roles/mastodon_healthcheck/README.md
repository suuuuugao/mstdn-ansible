# mastodon_healthcheck

Mastodon サービスの稼働確認を行う read-only ロール。

## 目的

以下をチェックし結果を表示する（何も変更しない）:

- systemd サービス状態確認（web / sidekiq / streaming）
- PostgreSQL 接続確認
- Redis 接続確認
- HTTP レスポンス確認（デフォルト: `localhost:3000/health`）

**すべてのタスクに `changed_when: false` を付与。このロールはいかなる変更も行わない。**

## 変数

| 変数名 | デフォルト | 説明 |
|--------|-----------|------|
| `mastodon_healthcheck_db_name` | `mastodon_production` | 接続確認する DB 名 |
| `mastodon_healthcheck_db_user` | `mastodon` | psql 実行ユーザ |
| `mastodon_healthcheck_redis_host` | `127.0.0.1` | Redis ホスト |
| `mastodon_healthcheck_redis_port` | `6379` | Redis ポート |
| `mastodon_healthcheck_http_url` | `http://localhost:3000/health` | HTTP 確認 URL |
| `mastodon_healthcheck_services` | `[mastodon-web, mastodon-sidekiq, mastodon-streaming]` | 確認する systemd サービス一覧 |

## 使い方

```bash
ansible-playbook -i inventory.yml healthcheck.yml
```

```yaml
- hosts: mastodon_servers
  roles:
    - mastodon_healthcheck
```

## 注意事項

- `failed_when: false` を使用しているため、個別チェックが失敗してもロールは停止しない（全結果をまとめて表示）
- 厳格モード（失敗で停止させたい場合）は `failed_when` を除去すること
- `become: true` が psql 実行のために必要
- このロールは playbook への配線を含まない（ロール単体完結）
