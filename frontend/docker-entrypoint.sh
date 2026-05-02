#!/bin/sh
set -eu

LOCKFILE_HASH_FILE="node_modules/.package-lock.sha256"
CURRENT_HASH="$(sha256sum package-lock.json | awk '{print $1}')"
SAVED_HASH=""

if [ -f "$LOCKFILE_HASH_FILE" ]; then
  SAVED_HASH="$(cat "$LOCKFILE_HASH_FILE")"
fi

if [ ! -d "node_modules" ] || [ "$CURRENT_HASH" != "$SAVED_HASH" ]; then
  npm install
  mkdir -p node_modules
  printf '%s' "$CURRENT_HASH" > "$LOCKFILE_HASH_FILE"
fi

exec npm run dev -- --host
