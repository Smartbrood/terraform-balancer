FROM nginx:alpine

RUN apk --no-cache add bash

COPY ./files/default.conf.template /etc/nginx/conf.d/default.conf.template
COPY ./files/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
