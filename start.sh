#!/bin/sh
# Start Meilisearch with production defaults for Railway.
# Every value below can be overridden by setting the variable on the service.
set -e

if [ -z "${MEILI_MASTER_KEY:-}" ]; then
  echo "MEILI_MASTER_KEY is not set. Set it to a random string of at least 16 characters." >&2
  exit 1
fi

export MEILI_ENV="${MEILI_ENV:-production}"
export MEILI_DB_PATH="${MEILI_DB_PATH:-/meili_data/data.ms}"
export MEILI_DUMP_DIR="${MEILI_DUMP_DIR:-/meili_data/dumps}"
export MEILI_SNAPSHOT_DIR="${MEILI_SNAPSHOT_DIR:-/meili_data/snapshots}"
# Listen on Railway's PORT on all interfaces (IPv6 and IPv4, for the private network too).
export MEILI_HTTP_ADDR="${MEILI_HTTP_ADDR:-[::]:${PORT:-7700}}"
export MEILI_NO_ANALYTICS="${MEILI_NO_ANALYTICS:-true}"
# Upgrade the on-disk database in place when the image version changes (Meilisearch >= 1.51).
# Set MEILI_UPGRADE_DB=false to turn this off and upgrade through a dump instead.
export MEILI_UPGRADE_DB="${MEILI_UPGRADE_DB:-true}"

exec /bin/meilisearch "$@"
