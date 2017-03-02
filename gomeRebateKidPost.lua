local guidcompressor = require "util.guid_compressor"
local kidresult = require "util.kid_result"
local httputil = require "util.http_util"
local sysconf = require "conf.sysconf"
local redis = require "resty.redis"



--forbidden method response
local function forbidden_method()
    ngx.log(ngx.WARN, "forbidden method")
    ngx.status = httputil.__HTTP_CODE__[1]
    ngx.say(kidresult.errMsg("forbidden method", tostring(httputil.__HTTP_CODE__[2])))
end

local function params_invaild(param, paramValue, jsonp)
    if httputil.isNotJsonp(jsonp) then
        ngx.header.content_type = httputil.__HTTP_CONTENT_TYPE__.json
        ngx.say(kidresult.errMsg(tostring(param).."  " .. tostring(paramValue) .. " is invalid", tostring(httputil.__HTTP_CODE__[4])))
    else
        ngx.header.content_type = httputil.__HTTP_CONTENT_TYPE__.text
        ngx.say(tostring(jsonp) .. "(" .. kidresult.errMsg(tostring(param).."  " .. tostring(paramValue) .. " is valid", tostring(httputil.__HTTP_CODE__[4])) .. ")")
    end
end

local function server_error(jsonp,err)
    if err ~= nil then
        ngx.log(ngx.ERR,"server error",err)
    end

    if httputil.isNotJsonp(jsonp) then
        ngx.header.content_type = httputil.__HTTP_CONTENT_TYPE__.json
        ngx.say(kidresult.errMsg(" server error !", tostring(httputil.__HTTP_CODE__[3])))
    else
        ngx.header.content_type = httputil.__HTTP_CONTENT_TYPE__.text
        ngx.say(tostring(jsonp).."("..kidresult.errMsg(" server error !", tostring(httputil.__HTTP_CODE__[3]))..")")
    end
end

local function check_param(params,jsonp)
    local flow = params["flow"]
    local userId = params["userId"]
    local callfrom = params["callfrom"]
    if httputil.isEmpty(flow) then
        params_invaild("flow",flow,jsonp)
        return false
    end
    if httputil.isEmpty(userId) then
        params_invaild("userId",userId,jsonp)
        return false
    end
    if httputil.isEmpty(callfrom) then
        params_invaild("callfrom",callfrom,jsonp)
        return false
    end

    return true

end

local function successResult(jsonp,kid,userId)
    if not kid or kid == '' then
        server_error(jsonp,nil)
    end
    if httputil.isNotJsonp(jsonp) then
        ngx.header.content_type = httputil.__HTTP_CONTENT_TYPE__.json
        ngx.say(kidresult.sucMsg("",userId, kid))
    else
        ngx.header.content_type = httputil.__HTTP_CONTENT_TYPE__.text
        ngx.say(tostring(jsonp) .. "(" .. kidresult.sucMsg("", userId, kid) .. ")")

    end
end


local request_method = ngx.var.request_method
local params
if httputil.isGet(request_method) then
    params = ngx.req.get_uri_args()
elseif httputil.isPost(request_method) then
    ngx.req.read_body()
    params = ngx.req.get_post_args()
else
    forbidden_method()
    return
end


if httputil.isTableEmpty(params) then
    params_invaild('param',params,nil)
    return
end

local skuId = params["skuId"]
local itemId = params["itemId"]
local flow = params["flow"]
local userId = params["userId"]
local parentKid = params["parentKid"]
local merchantId = params["merchantId"]
local itemUrl = params["itemUrl"]
local distributorId = params["distributorId"]
local callfrom = params["callfrom"]
local jsonp = params["jsonp"]


if not check_param(params,jsonp) then
    return
end



--redis

local red = redis:new()
red:set_timeout(sysconf._REDIS_CONF.timeout)

local ok, err = red:connect(sysconf._REDIS_CONF.host, sysconf._REDIS_CONF.port)
if not ok then
    server_error(jsonp,err)
    return
end

ok,err = red:auth(sysconf._REDIS_CONF.password)
if not ok then
    server_error(jsonp,err)
    return
end


local kid = guidcompressor.get_new_globally_unique_id()

local parentKid_url
if not httputil.isEmpty(parentKid) then

     parentKid_url= red:get(sysconf._KID_CONF.prefix..parentKid)
end

local current_url

if type(parentKid_url) == 'string' then
    current_url = parentKid_url.."/"..userId
else
    current_url = "/"..userId
end



red:init_pipeline()
red:set(sysconf._KID_CONF.prefix..kid,current_url)
red:expire(sysconf._KID_CONF.prefix..kid,sysconf._KID_CONF.expire)
local results, err = red:commit_pipeline()

if not results then
    server_error(jsonp,err)
    return
end


successResult(jsonp,kid,userId)


local ok, err = red:set_keepalive(10000, 100)
if not ok then
    ngx.log(ngx.ERR,"failed to set keepalive: ", err)
    return
end




























