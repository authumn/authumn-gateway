#!/bin/sh
envsubst \
  '$TOKEN_URL $USER_URL $API_URL $SERVER_NAME $MOUNT_POINT' < \
   conf/nginx.conf.template > \
   conf/nginx.conf

/usr/local/openresty/bin/openresty -g 'daemon off; error_log /dev/stderr info;' -c /conf/nginx.conf
