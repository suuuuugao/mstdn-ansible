# Ansible Playbook for Mastodon

多言語：  
[English](README.md)

## 概要

このAnsibleプレイブックは分散型SNS「[マストドン](https://joinmastodon.org/)」を構築・運用するためのものです。

マストドン公式は[Ansibleで自動化するためのリポジトリを公開](https://github.com/mastodon/mastodon-ansible)していますが、ここ数年ほとんどアップデートされていません。

また、とても特殊な書き方をしておりAnsibleベストプラクティスに基づいていないために保守性や拡張性がありません。

このプロジェクトの目標は、マストドンサーバを運用するための新しいプレイブックを公開することにあります。

## 使い方

```bash
ansible-playbook -i inventory.yml mastodon_setup.yml
```

> **注意**: `mastodon-setup.yml`（旧モノリシック Playbook）は参照目的で `legacy/` へ退避済みです。