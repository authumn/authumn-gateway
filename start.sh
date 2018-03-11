#!/bin/sh
envsubst \
  '$TOKEN_URL $USER_URL $API_URL $SERVER_NAME' < \
   conf/nginx.conf.template > \
   conf/nginx.conf

/usr/local/openresty/bin/openresty -g 'daemon off;' -c /conf/nginx.conf
