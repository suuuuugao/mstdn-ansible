#!/usr/bin/env bash
# cleanup-mstdn-ci.sh — mstdn-ci project 限定の孤児 incus インスタンス掃除
# 対象: mstdn-ci-* にマッチするインスタンスのうち、STALE_HOURS 以上経過したもの
# ★ default project / 他サービスには絶対触れない
set -euo pipefail

PROJECT=mstdn-ci
PREFIX=mstdn-ci-
STALE_HOURS=${STALE_HOURS:-3}

log() { echo "[$(date -Iseconds)] $*"; }

stale_instances() {
  incus list --project "$PROJECT" --format csv -c "n,S,4" 2>/dev/null \
    | awk -F',' -v prefix="$PREFIX" '$1 ~ "^"prefix' \
    | awk -F',' '{print $1}'
}

main() {
  log "Starting cleanup for project=$PROJECT prefix=$PREFIX stale=${STALE_HOURS}h"
  local count=0
  while IFS= read -r name; do
    [ -z "$name" ] && continue
    log "Deleting stale instance: $name"
    incus delete --force "$name" --project "$PROJECT" && ((count++)) || log "WARN: failed to delete $name"
  done < <(stale_instances)
  log "Done. Deleted $count instance(s)."
}

main "$@"
