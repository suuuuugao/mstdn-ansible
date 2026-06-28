# legacy/

このディレクトリには旧来の Playbook を退避しています。

- `mastodon-setup.yml`: 旧モノリシック Playbook（351行）。`mastodon_setup.yml`（Role分割版）を正式入口とした
  ため legacy 化。参照目的でのみ残す。

**新しい実行コマンド**: `ansible-playbook -i inventory.yml mastodon_setup.yml`
