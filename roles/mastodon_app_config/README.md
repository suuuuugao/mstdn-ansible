mastodon_app_config
===================

Mastodon アプリの `.env` 設定ファイルを構成する。
`.env.production.sample` をベースにコピーし、シークレット (SECRET_KEY_BASE / OTP_SECRET / VAPID キー) を生成してすべての設定値を `lineinfile` で書き込む。

対応 OS
-------

- Ubuntu 22.04 LTS
- Ubuntu 24.04 LTS

(Incus システムコンテナ経由で Ansible 管理)

必要変数
--------

### デフォルト値あり

| 変数名 | デフォルト値 | 説明 |
|--------|-------------|------|
| `mastodon_app_path` | `/home/mastodon/live` | Mastodon アプリルートディレクトリ |
| `mastodon_app_anyenv_path` | `/home/mastodon/.anyenv` | anyenv インストール先 |
| `mastodon_app_user_name` | `mastodon` | アプリ実行 OS ユーザ名 |
| `mastodon_app_environment` | `production` | Rails 環境 (`RAILS_ENV`) |

### 必須 (デフォルトなし)

| 変数名 | 説明 |
|--------|------|
| `mastodon_app_local_domain` | Mastodon のドメイン名 (例: `example.com`) |
| `mastodon_redis_hostname` | Redis ホスト |
| `mastodon_redis_port` | Redis ポート |
| `mastodon_pg_hostname` | PostgreSQL ホスト |
| `mastodon_pg_username` | PostgreSQL ユーザ名 |
| `mastodon_pg_name` | PostgreSQL データベース名 |
| `mastodon_pg_password` | PostgreSQL パスワード |
| `mastodon_pg_port` | PostgreSQL ポート |
| `mastodon_es_enabled` | Elasticsearch 有効フラグ (`true`/`false`) |
| `mastodon_es_hostname` | Elasticsearch ホスト |
| `mastodon_es_port` | Elasticsearch ポート |
| `mastodon_es_username` | Elasticsearch ユーザ名 |
| `mastodon_es_password` | Elasticsearch パスワード |
| `mastodon_smtp_server` | SMTP サーバホスト |
| `mastodon_smtp_port` | SMTP ポート |
| `mastodon_smtp_login` | SMTP ログイン名 |
| `mastodon_smtp_password` | SMTP パスワード |
| `mastodon_smtp_from_address` | メール送信元アドレス |
| `mastodon_s3_enabled` | S3 有効フラグ (`true`/`false`) |
| `mastodon_s3_bucket` | S3 バケット名 |
| `mastodon_s3_aws_access_key_id` | AWS アクセスキー ID |
| `mastodon_s3_aws_secret_access_key` | AWS シークレットキー |
| `mastodon_s3_alias_host` | S3 エイリアスホスト |

生成ファイル・ディレクトリ
--------------------------

| パス | 内容 |
|------|------|
| `{{ mastodon_app_path }}/.env` | Mastodon アプリ環境設定ファイル |

systemd / nginx / postgresql への影響
--------------------------------------

直接的な影響なし。ただし `.env` の SECRET_KEY_BASE / OTP_SECRET / VAPID キーが変更された場合、
実行中の `mastodon-web`、`mastodon-sidekiq`、`mastodon-streaming` の再起動が必要になる。

再実行時の挙動 (冪等性)
------------------------

- **copy-envfile.yml**: `force: false` のため、`.env` が既に存在する場合はコピーをスキップ (`ok`)。
- **generate-secrets.yml**: SECRET_KEY_BASE / OTP_SECRET は毎回 `/dev/urandom` から生成される。
  VAPID キーも毎回 `rake mastodon:webpush:generate_vapid_key` で生成される。
- **set-app-config.yml**: シークレット系 (SECRET_KEY_BASE / OTP_SECRET / VAPID) は `.env` が新規コピーされた場合のみ書き込まれる (`when: __result_copy_envfile.changed`)。
  その他の設定項目 (LOCAL_DOMAIN / DB_* / REDIS_* 等) は `lineinfile` で常に上書きされる (`changed` は差異がある場合のみ)。

使用 tags
---------

なし。

Requirements
------------

- `mastodon_app_repository` ロールで Mastodon リポジトリがクローン済みであること (`.env.production.sample` が存在すること)。
- `mastodon_app_anyenv` ロールで rbenv / bundler が利用可能であること (VAPID キー生成に使用)。

Example Playbook
----------------

    - hosts: mastodon_servers
      roles:
        - role: mastodon_app_config
          vars:
            mastodon_app_local_domain: "example.com"
            mastodon_pg_hostname: "localhost"
            mastodon_pg_username: "mastodon"
            mastodon_pg_name: "mastodon_production"
            mastodon_pg_password: "{{ vault_pg_password }}"
            mastodon_pg_port: 5432
            mastodon_redis_hostname: "localhost"
            mastodon_redis_port: 6379

License
-------

BSD

Author Information
------------------

guskma
