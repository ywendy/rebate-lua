local redis = require "resty.redis_iresty"
local resultmsg = require "util.result_msg"
local tableutil = require "util.table_util"
local mathtool = require "util.math_tool"
local rebatekey = require "util.rebate_key"

local request_method = ngx.var.request_method
local args

ngx.status = 200
ngx.header.content_type = "application/json;charset=utf8"
if "GET" == request_method then
    args = ngx.req.get_uri_args()
else
    ngx.log(ngx.WARN, "forbidden method")
    ngx.status = 403
    ngx.say(resultmsg.errMsg("forbiden method", 403))
    return
end


if tableutil.isTableEmpty(args) then
    ngx.status = 422
    ngx.say(resultmsg.errMsg("params invalid", 422))
    return
end


local itemId = args["id"]
local price = args["price"]
local callback_method = args["jsonp"]

ngx.log(ngx.INFO, "Query Params: itemId=" .. tostring(itemId) .. ",price=" .. tostring(price) .. ",callback=" .. tostring(callback_method))

if price == nil or price == '' or itemId == '' or itemId == nil then
    ngx.status = 422
    if callback_method == nil or callback_method == '' then
        ngx.say(resultmsg.errMsg("params invalid", 422))
    else
        ngx.header.content_type = "text/plain;charset=utf8"
        ngx.say(tostring(callback_method).."("..resultmsg.errMsg("params invalid",422)..")")
    end
    return
end





local red = redis:new()
local authres, err = red:auth("gome123456")

if not authres then
    ngx.status = 500
    ngx.log(ngx.ERR, authres, err)
    if callback_method == nil or callback_method == '' then
        ngx.say(resultmsg.errMsg("server error", 500))
    else
        ngx.header.content_type = "text/plain;charset=utf8"
        ngx.say(tostring(callback_method).."("..resultmsg.errMsg("server error",500)..")")
    end

    return
end

local rebate_platform_share_key = rebatekey.getRebatePlatformShareKey(itemId)
local rebate_platform_distribute_key = rebatekey.getRebatePlatformDistributeKey(itemId)





local ratio, err = red:get(rebate_platform_share_key)
ngx.log(ngx.INFO, "rebate_platform_share_key=" .. tostring(rebate_platform_share_key) .. ",pdratio=" .. tostring(ratio))
if not ratio then
    ngx.status = 200
    if callback_method == nil or callback_method == '' then
        ngx.say(resultmsg.sucMsg(itemId, "0.00"))
    else
        ngx.header.content_type = "text/plain;charset=utf8"
        ngx.say(tostring(callback_method).."("..resultmsg.sucMsg(itemId, "0.00")..")")
    end

    return
end

local pdratio, err = red:get(rebate_platform_distribute_key)
ngx.log(ngx.INFO, "rebate_platform_distribute_key=" .. tostring(rebate_platform_distribute_key) .. ",pdratio=" .. tostring(pdratio))
if not pdratio then
    ngx.status = 200
    if callback_method == nil or callback_method == '' then
        ngx.say(resultmsg.sucMsg(itemId, "0.00"))
    else
        ngx.header.content_type = "text/plain;charset=utf8"
        ngx.say(tostring(callback_method).."("..resultmsg.sucMsg(itemId, "0.00")..")")
    end
    return
end




price = tonumber(price) * 100

local rebate_share_price = price * ratio * 0.0001 * 0.01
local rebate_distribute_price = price * pdratio * 0.0001 * 0.01


local rebate_price = mathtool.round((rebate_share_price + rebate_distribute_price), 2)

if callback_method == nil or callback_method == '' then
    ngx.say(resultmsg.sucMsg(itemId, rebate_price))
else
    ngx.header.content_type = "text/plain;charset=utf8"
    local jsonp_result = tostring(callback_method) .. "(" .. resultmsg.sucMsg(itemId, rebate_price) .. ")"
    ngx.say(jsonp_result)
end


