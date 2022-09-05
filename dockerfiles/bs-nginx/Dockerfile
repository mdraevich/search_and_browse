FROM nginx:stable-alpine

LABEL maintainer="https://github.com/mdraevich"



EXPOSE 80/tcp

RUN apk update \
	&& apk add nginx-mod-http-xslt-filter \
	&& apk add jq uuidgen 
RUN sed -i '1s/^/include \/etc\/nginx\/modules\/*.conf;\n/' /etc/nginx/nginx.conf

COPY ./install /
