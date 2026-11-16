# Meilisearch on Railway

This repo is the source of the **Meilisearch** template on Railway. It deploys [Meilisearch](https://www.meilisearch.com/), the open-source search engine, as one service built from this repo.

## What it deploys

- **Meilisearch v1.56.2**, from the official image `getmeili/meilisearch:v1.56.2`, pinned by digest in the [`Dockerfile`](Dockerfile).
- Production mode (`MEILI_ENV=production`): every route except `GET /health` needs the master key.
- A volume at `/meili_data` for the database (`data.ms`), dumps and snapshots, so your indexes survive redeploys.
- A public Railway domain, with Railway's health check on `/health`.
- Telemetry off (`MEILI_NO_ANALYTICS=true`).

## Variables

| Variable | Default | What it does |
|---|---|---|
| `MEILI_MASTER_KEY` | `${{secret(32)}}` | Master key. Railway generates it; find it on the service's Variables tab. Send it as `Authorization: Bearer ...`. Use it to create scoped API keys, and don't ship it to browsers. |
| `PORT` | `7700` | Port Meilisearch listens on. Railway's domain points to it. |

The start script ([`start.sh`](start.sh)) sets the rest, and any of them can be overridden by adding the variable to the service: `MEILI_ENV`, `MEILI_DB_PATH`, `MEILI_DUMP_DIR`, `MEILI_SNAPSHOT_DIR`, `MEILI_HTTP_ADDR`, `MEILI_NO_ANALYTICS`, `MEILI_UPGRADE_DB`. Other options, such as `MEILI_MAX_INDEXING_MEMORY` or `MEILI_SCHEDULE_SNAPSHOT`, are in Meilisearch's [configuration reference](https://www.meilisearch.com/docs/learn/self_hosted/configure_meilisearch_at_launch).

## First steps

```sh
# Check the instance (no key needed)
curl https://YOUR-DOMAIN/health

# List API keys: Meilisearch creates a default search key and a default admin key
curl -H "Authorization: Bearer YOUR_MASTER_KEY" https://YOUR-DOMAIN/keys
```

Use the default search key in front-end code and the admin key in back-end code. Other Railway services in the same project can reach Meilisearch privately at `http://${{Meilisearch.RAILWAY_PRIVATE_DOMAIN}}:7700`.

## Updates

New Meilisearch versions arrive as a change to the pinned image in this repo's `main` branch. Railway then shows an "update available" notice on projects deployed from the template, and you choose when to apply it. Read [`CHANGELOG.md`](CHANGELOG.md) first.

The start script sets `MEILI_UPGRADE_DB=true`, so Meilisearch upgrades its database in place when it starts on a newer version. Meilisearch's docs warn that an upgrade isn't atomic, so take a backup before you apply an update: a [snapshot or dump](https://www.meilisearch.com/docs/learn/data_backup/snapshots_vs_dumps), or a Railway volume backup. Databases created before Meilisearch v1.12 can't be upgraded this way.
