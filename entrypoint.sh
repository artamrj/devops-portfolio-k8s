#!/bin/sh
envsubst < /usr/share/nginx/html/index.template.html > /usr/share/nginx/html/index.html

exec nginx -g 'daemon off;'