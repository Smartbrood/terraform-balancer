#!/usr/bin/env bash
set -euo pipefail

envsubst '$PRIVATE_ALB' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

exec "$@"


