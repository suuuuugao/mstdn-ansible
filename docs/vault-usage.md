# Ansible Vault Usage

Sensitive variables are stored in `group_vars/all/vault.yml` (AES256 encrypted).

## Setup vault password

```bash
echo "your-vault-password" > .vault_pass.txt
chmod 600 .vault_pass.txt
# .vault_pass.txt is gitignored — never commit it
```

## Edit vault

```bash
ansible-vault edit --vault-password-file .vault_pass.txt group_vars/all/vault.yml
```

## Run playbook with vault

```bash
ansible-playbook -i inventory.yml mastodon_setup.yml --vault-password-file .vault_pass.txt
# or interactively:
ansible-playbook -i inventory.yml mastodon_setup.yml --ask-vault-pass
```

## Variables in vault.yml

| Variable | Description | Referenced in |
|----------|-------------|---------------|
| `vault_mastodon_pg_password` | PostgreSQL user password | roles/mastodon_app_config |
| `vault_postgresql_password` | `postgresql.password` in group_vars/all/main.yml | group_vars/all/main.yml |
| `vault_elasticsearch_password` | `elasticsearch.password` in group_vars/all/main.yml | group_vars/all/main.yml |
| `vault_mastodon_secret_key_base` | Rails SECRET_KEY_BASE (64+ chars) | roles/mastodon_app_config |
| `vault_mastodon_otp_secret` | OTP_SECRET (64+ chars) | roles/mastodon_app_config |
| `vault_mastodon_vapid_private_key` | VAPID private key | roles/mastodon_app_config |
| `vault_mastodon_vapid_public_key` | VAPID public key | roles/mastodon_app_config |
| `vault_mastodon_active_record_encryption_*` | ActiveRecord encryption keys | roles/mastodon_app_config |

Replace all `CHANGE_ME_*` placeholders with real values before production use.

## Vault wiring in group_vars

`group_vars/all/main.yml` references vault variables via Jinja2 templating:

```yaml
# group_vars/all/main.yml
postgresql:
  password: '{{ vault_postgresql_password }}'

elasticsearch:
  password: '{{ vault_elasticsearch_password }}'
```

These resolve at playbook runtime when `--vault-password-file` is provided.
Plain-text passwords (`mastodon123`, `password`) have been removed from `main.yml`.
