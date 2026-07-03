# mastodon_maintenance

Mastodon のメンテナンスモードを切り替えるロール。

## 目的

`mastodon_maintenance_enable` の値に応じてメンテナンスモードを ON/OFF する:

**ON (`mastodon_maintenance_enable: true`)**:
- mastodon-web / mastodon-sidekiq / mastodon-streaming を停止
- メンテナンス HTML ページをデプロイ
- maintenance nginx 設定を配置

**OFF (`mastodon_maintenance_enable: false`、デフォルト)**:
- mastodon サービスを起動
- メンテナンスページを削除
- nginx をリロード

## 変数

| 変数名 | デフォルト | 説明 |
|--------|-----------|------|
| `mastodon_maintenance_enable` | `false` | `true` でメンテナンスモード ON |
| `mastodon_maintenance_app_path` | `/home/mastodon/live` | Mastodon アプリケーションパス |
| `mastodon_maintenance_nginx_available_dir` | `/etc/nginx/sites-available` | nginx 設定ディレクトリ |
| `mastodon_maintenance_nginx_enabled_dir` | `/etc/nginx/sites-enabled` | nginx 有効化ディレクトリ |
| `mastodon_maintenance_nginx_site_name` | `mastodon` | nginx サイト名 |
| `mastodon_maintenance_page_dest` | `/var/www/html/maintenance.html` | メンテナンスページ配置先 |
| `mastodon_maintenance_services` | `[mastodon-web, mastodon-sidekiq, mastodon-streaming]` | 操作する systemd サービス一覧 |

## 使い方

```bash
# メンテナンスモード ON
ansible-playbook -i inventory.yml maintenance.yml \
  -e mastodon_maintenance_enable=true

# メンテナンスモード OFF
ansible-playbook -i inventory.yml maintenance.yml \
  -e mastodon_maintenance_enable=false
```

```yaml
# playbook での指定例
- hosts: mastodon_servers
  roles:
    - role: mastodon_maintenance
      vars:
        mastodon_maintenance_enable: true
```

## 注意事項

- デフォルト `false` はメンテナンスモード OFF（サービス起動）を意味する
- `become: true` が必要
- このロールは playbook への配線を含まない（ロール単体完結）
- playbook への組み込みは issue #8 を参照
