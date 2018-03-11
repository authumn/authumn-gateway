local utils={}
local REDIS_HOST = os.getenv('REDIS_HOST') or '127.0.0.1'
local REDIS_PORT = os.getenv('REDIS_PORT') or 6379
local REDIS_DB = os.getenv('REDIS_DB') or 0
local REDIS_AUTH = os.getenv('REDIS_AUTH')
-- set $REDIS_HOST "127.0.0.1";
-- set $REDIS_PORT 6379;
-- set $REDIS_DB 1;
-- set $REDIS_AUTH "your-redis-pass";
--
function utils.redis_connect()
    local redis = require "resty.redis"
    local red = redis:new()
    red:set_timeout(100) -- 100ms

    local ok, err = red:connect(REDIS_HOST, REDIS_PORT)
    if not ok then
        ngx.log(ngx.ERR, "failed to connect to redis: ", err)
        return nil
    end

    if REDIS_AUTH then
        local ok, err = red:auth(REDIS_AUTH)
        if not ok then
            ngx.log("failed to authenticate: ", err)
            return nil
        end
    end

    if REDIS_DB then
        local ok, err = red:select(REDIS_DB)
        if not ok then
            ngx.log("failed to select db: ", REDIS_DB, " ", err)
            return nil
        end
    end

    return red
end

function utils.redis_close(red)
    local ok, err = red:close()
    if not ok then
        ngx.log(ngx.ERR, "failed to close: ", err)
    end
end

function utils.redkey(kid)
    local red = utils.redis_connect()

    local res, err = red:exists(kid)

    utils.redis_close(red)

    return res
end

function utils.abort(status, message)
    ngx.status = ngx[status]
    ngx.header.content_type = "application/json; charset=utf-8"
    ngx.say("{\"error\": \"", message ,"\"}")
    ngx.exit(ngx[status])
end

return utils
