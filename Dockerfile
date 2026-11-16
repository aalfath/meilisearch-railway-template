# Meilisearch for Railway: the official image, pinned by version and digest.
# To update: bump the tag and digest below, add a CHANGELOG.md entry, test, merge to main.
FROM getmeili/meilisearch:v1.56.2@sha256:9600db22be3fcbf3d506176d3a73dd70a65c5719d9aa1d2837355b75afb8f4fb

COPY start.sh /usr/local/bin/railway-start.sh
RUN chmod 755 /usr/local/bin/railway-start.sh

# The base image presets MEILI_HTTP_ADDR=0.0.0.0:7700; clear it so start.sh can bind
# to Railway's PORT on IPv6 and IPv4.
ENV MEILI_HTTP_ADDR=""

# Data lives in /meili_data (mount a volume there).
WORKDIR /meili_data
EXPOSE 7700

ENTRYPOINT ["tini", "--", "/usr/local/bin/railway-start.sh"]
