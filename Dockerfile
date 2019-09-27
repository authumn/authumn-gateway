FROM openresty/openresty:alpine-fat

ENV LUA_VERSION 5.2
ENV LUA_PACKAGE lua${LUA_VERSION}

ENV JWT_SECRET change_me

ENV TOKEN_URL http://localhost:2301/token
ENV USER_URL http://localhost:2302/user
ENV SERVER_NAME authumn-gateway

ENV REDIS_HOST "127.0.0.1";
ENV REDIS_PORT 6379;
ENV REDIS_DB 1;
ENV RESOLVER "127.0.0.11 valid=30s"

ENV API_URL http://localhost:2303/
ENV MOUNT_POINT '/v1'

# To configure extra api's:
# ENV API_2_URL http://localhost:2303/
# ENV API_2_MOUNT_POINT /other-api
# etc.

EXPOSE 80

RUN apk update
RUN apk add openssl-dev git

RUN apk add ${LUA_PACKAGE}

RUN luarocks install lua-resty-http
RUN luarocks install lua-resty-session
RUN luarocks install lua-resty-jwt
RUN luarocks install lua-resty-openidc
RUN luarocks install lustache

COPY ./conf /conf
COPY ./certs /certs
COPY ./logs /logs
COPY ./start.sh /start.sh

COPY ./www/*.html /usr/local/openresty/nginx/html/

RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
