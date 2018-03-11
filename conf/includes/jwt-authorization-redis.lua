local utils = require "conf.includes.utils"

local jwt = require "resty.jwt"

local auth_header = ngx.var.http_Authorization

if auth_header then
    _, _, token = string.find(auth_header, "Bearer%s+(.+)")
end

if token == nil then
    utils.abort('HTTP_UNAUTHORIZED', "missing JWT token or Authorization header")
end

local jwt_obj = jwt:load_jwt(token)

if not jwt_obj.valid then
    ngx.log(ngx.ERR, "invalid jwt:", jwt_obj)
    utils.abort("HTTP_BAD_REQUEST", "invalid jwt")
end

local verified = jwt:verify_jwt_obj(key, jwt_obj, 30)

if not verified.verified then
    utils.abort('HTTP_UNAUTHORIZED', jwt_obj.reason)
end

if flush then
    -- flush all cached keys, if a new valid key showed up
    -- the older ones were expired
    jwt_key_dict:flush_all()
    jwt_key_dict:set(kid, key)
end
