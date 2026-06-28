# Ansible Playbook for Mastodon

Other language:  
[日本語](README_ja.md)

## Overview

This Ansible playbook was created to build and operate the distributed social network service "[Mastodon](https://joinmastodon.org/)".

[The official Mastodon repository is available for automation with Ansible](https://github.com/mastodon/mastodon-ansible), but it has hardly been updated in the last few years.

It is also not maintainable or scalable because it is written in a very specific way and not based on Ansible best practices.

The goal of this project is to publish a new playbook for running a mastodon server.

## How to use

```bash
ansible-playbook -i inventory.yml mastodon_setup.yml
```

> **Note**: `mastodon-setup.yml` (old monolithic playbook) has been moved to `legacy/` for reference only.