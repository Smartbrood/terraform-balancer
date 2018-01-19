FROM smartbrood/caddy:frontend

RUN mkdir -p /var/www/html/canary

COPY ./files/Caddyfile /etc/Caddyfile
COPY ./files/index.md  /var/www/html/index.md
COPY ./files/index.md  /var/www/html/canary/index.md
