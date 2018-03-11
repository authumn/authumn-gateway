# Authumn Nginx

Proxy gateway server

### Hosts

Nginx is configured to serve the following hosts

#### [4200] Angular Frontend

This is the angular frontend in development mode.
The proxy is configured to also understand hot reloading.

In production angular is statically.

### [2301] Token Server

This is the token server. Currently configured to handle token issueing.

It depends on the user server being available because it will make 
an authentication request to verify email and password.

The user server itself is never accessed directly, only in development mode.

So this service should just be made available and will not be handled by the proxy server.

### [2302] User Server

As said, this server will not be targeted by nginx.
However it must be made available internally.

### [2303] Api server

This is the main api server, the proxy will route authenticated
requests to this server. The mount point is /api


## Redis

## Error logging and propegation.
