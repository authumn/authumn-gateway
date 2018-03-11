FROM openresty/openresty:alpine-fat

# Should match with the JWT_SECRET of the token service.
ENV JWT_SECRET change_me

ENV TOKEN_URL http://localhost:2301/token
ENV USER_URL http://localhost:2302/user
ENV API_URL http://localhost:2303/api
ENV SERVER_NAME authumn

EXPOSE 80

RUN apk update
RUN apk add openssl-dev git

RUN luarocks install lua-resty-http
RUN luarocks install lua-resty-session
RUN luarocks install lua-resty-jwt
RUN luarocks install lua-resty-openidc

COPY ./conf /conf
COPY ./certs /certs
COPY ./logs /logs

COPY ./backend-not-found.html /var/www/html/backend-not-found.html

RUN envsubst \
  '$TOKEN_URL $USER_URL $API_URL $SERVER_NAME' < \
   conf/nginx.conf.template > \
   conf/nginx.conf

ENTRYPOINT ["/usr/local/openresty/bin/openresty", "-g", "daemon off;", "-c", "/conf/nginx.conf"]
