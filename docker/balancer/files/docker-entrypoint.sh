#!/usr/bin/env bash
set -euo pipefail

envsubst '$PRODUCTION,$CANARY' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

exec "$@"


