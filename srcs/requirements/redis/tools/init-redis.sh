#!/bin/bash
set -e

if [ -z "${REDIS_PASSWORD}" ]; then
    echo "REDIS_PASSWORD non defini" >&2
    exit 1
fi

echo "Demarrage de Redis..."
exec redis-server /etc/redis/redis.conf --requirepass "${REDIS_PASSWORD}"
