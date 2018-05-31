local cjson = require('cjson')
local openidc = require('conf/includes/openidc')
local utils = require('conf/includes/utils')

ngx.log(ngx.DEBUG, "check.lua started")

local secret = os.getenv("JWT_SECRET")

local opts = {
    secret = secret,
    client_secret = secret
}

-- call bearer_jwt_verify for OAuth 2.0 JWT validation
local json, err = openidc.bearer_jwt_verify(opts)

ngx.log(ngx.DEBUG, "check.lua verified bearer_jwt_verify")

if err or not json then
    ngx.status = 403
    ngx.say(err and err or "no access_token provided")
    ngx.exit(ngx.HTTP_FORBIDDEN)
end
ngx.log(ngx.DEBUG, "Made it!")
ngx.log(ngx.DEBUG, cjson.encode(json))

local redisKey = 'tokens:' .. json.jti

ngx.log(ngx.DEBUG, 'checking for key' .. redisKey)

local result = utils.redkey(redisKey)
ngx.log(ngx.DEBUG, cjson.encode(result))

if result < 1 then
    ngx.status = 403
    ngx.say(err and err or "token is revoked")
    ngx.exit(ngx.HTTP_FORBIDDEN)
end
