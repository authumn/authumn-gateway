#!/bin/sh
lua configure.lua > conf/nginx.conf

cat conf/nginx.conf

/usr/local/openresty/bin/openresty -g 'daemon off; error_log /dev/stderr info;' -c /conf/nginx.conf
