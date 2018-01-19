FROM smartbrood/caddy:frontend

RUN mkdir -p /var/www/html/production

COPY ./files/Caddyfile /etc/Caddyfile
COPY ./files/index.md  /var/www/html/index.md
COPY ./files/index.md  /var/www/html/production/index.md
