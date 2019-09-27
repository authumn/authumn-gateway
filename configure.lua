local lustache = require 'lustache'
local open = io.open
local getenv = os.getenv

local path = './conf/nginx.conf.template'
local file = open(path, 'r')
local content = file:read '*all'

file:close()

local apis = {}

local i = 1
while true do
  local url = getenv('API_' .. i + 1 .. '_URL')
  local mount_point = getenv('API_' .. i + 1 .. '_MOUNT_POINT')

  if url == nil or mount_point == nil then
    break
  else
    apis[i] = {
      api_url = url,
      mount_point = mount_point
    }
  end

  i = i + 1
end

view_model = {
  JWT_SECRET = getenv('JWT_SECRET'),
  TOKEN_URL = getenv('TOKEN_URL'),
  USER_URL = getenv('USER_URL'),
  API_URL = getenv('API_URL'),
  SERVER_NAME = getenv('SERVER_NAME'),
  REDIS_HOST = getenv('REDIS_HOST'),
  REDIS_PORT = getenv('REDIS_PORT'),
  REDIS_DB = getenv('REDIS_DB'),
  RESOLVER = getenv('RESOLVER'),
  MOUNT_POINT = getenv('MOUNT_POINT'),
  apis = apis,
  calc = function ()
    return 2 + 4
  end
}

output = lustache:render(content, view_model)

print(output)

