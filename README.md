# Authumn Gateway Service

The Authumn Gateway service is a minimum setup to protect a single api endpoint.

In conjunction with the Token & User service it offers a simple registration and login flow,
which enables the user to access the protected api.

Once a user has received a valid token the Authumn Gateway service will take care of the authorization to the `Api Service`.

Access to the `Api service` requires a valid token issued by the token service.

Cors is automatically handled for all backend services.

## Backend Services

The gateway service is configured to proxy to the following backend services.

### [2301] [Token Service](https://github.com/authumn/authumn-token)

This is the token service.

It depends on the user service being available while it will make an authentication request to verify email and password.

The token service will be available at: `https://<authumn_gateway_url>/<MOUNT_POINT>/token`

### [2302] [User Service](https://github.com/authumn/authumn-user)

The user service handles the registration and logins.

The user service will be available at: `https://<authumn_gateway_url>/<MOUNT_POINT>/user`

### [2303] Api service

This is the main api service, the proxy will route authenticated requests to this service.
By default the mount point is /v1

The token service will be available at: `https://<authumn_gateway_url>/<MOUNT_POINT>/`

### Docker

The following environment variables can be configured:

|Name|Type|Description|Default|
|---|---|---|---|
|`SERVER_NAME`|String|Server Name|`authumn-gateway`|
|`TOKEN_URL`|String|Url of the [Token Service](https://github.com/authumn/authumn-token)|`http://localhost:2301/token`|
|`USER_URL`|String|Url of the [User Service](https://github.com/authumn/authumn-user)|`http://localhost:2302/user`|
|`API_URL`|String|Api Service Url|`http://localhost:2303/api`|
|`JWT_SECRET`|String|JWT Secret to sign the tokens|`change_me`|
|`REDIS_HOST`|String|Redis host of the [token service]()|`localhost`|
|`REDIS_PORT`|String|Redis port of the [token service](https://github.com/authumn/authumn-token)|`6379`|
|`REDIS_DATABASE`|Number|Redis database used by the [token service](https://github.com/authumn/authumn-token)|`1`|
|`REDIS_AUTH`|String|Redis auth used by the [token service](https://github.com/authumn/authumn-token)||
|`MOUNT_POINT`|String|Mount point|/v1|
|`API_{x}_URL`|String|Additional Api Service Url|`e.g. http://localhost:2309`|
|`API_{x}_MOUNT_POINT`|String|Additional Api Mount point |`e.g. /other-api`|


