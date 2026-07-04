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

| Variable | Description |
|----------|-------------|
| `vault_mastodon_pg_password` | PostgreSQL user password |
| `vault_mastodon_secret_key_base` | Rails SECRET_KEY_BASE (64+ chars) |
| `vault_mastodon_otp_secret` | OTP_SECRET (64+ chars) |
| `vault_mastodon_vapid_private_key` | VAPID private key |
| `vault_mastodon_vapid_public_key` | VAPID public key |
| `vault_mastodon_active_record_encryption_*` | ActiveRecord encryption keys |

Replace all `CHANGE_ME_*` placeholders with real values before production use.
