FROM nginx:stable-alpine

LABEL maintainer="https://github.com/mdraevich"
LABEL description="NGINX + XSLT plugin"

EXPOSE 80/tcp

RUN apk update && apk add nginx-mod-http-xslt-filter





COPY ./install /



RUN sed -i '1s/^/include \/etc\/nginx\/modules\/*.conf;\n/' /etc/nginx/nginx.conf