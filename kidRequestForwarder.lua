--
-- Created by IntelliJ IDEA.
-- User: yaojian
-- Date: 2016/12/10
-- Time: 16:59
-- To change this template use File | Settings | File Templates.
--

local http = require "resty.http"
local kidresult = require "util.kid_result"
local json = require "dkjson"
local mathtool = require "util.math_tool"
ngx.status = 200
ngx.header.content_type = "application/json;charset=utf8"

local params
local request_method = ngx.var.request_method
if request_method == 'GET' then
    params = ngx.req.get_uri_args()
else
    ngx.say(kidresult.errMsg("forbidden method", "403"))
    return
end

if not params or params == '' then
    ngx.say(kidresult.errMsg("params is null", "422"))
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

if skuId == nil or "" == skuId then
    if not jsonp or jsonp == '' then
        ngx.say(kidresult.errMsg("skuId " .. tostring(skuId) .. " is invalid", "422"))
    else
        ngx.header.content_type = "text/plain;charset=utf8"
        ngx.say(tostring(jsonp) .. "(" .. kidresult.errMsg("skuId " .. tostring(skuId) .. " is valid", "422") .. ")")
    end
    return
end


if itemId == nil or "" == itemId then
    if not jsonp or jsonp == '' then
        ngx.say(kidresult.errMsg("itemId " .. tostring(itemId) .. " is invalid", "422"))
    else
        ngx.header.content_type = "text/plain;charset=utf8"
        ngx.say(tostring(jsonp) .. "(" .. kidresult.errMsg("itemId " .. tostring(itemId) .. " is invalid", "422") .. ")")
    end
    return
end


if not flow or flow == '' then
    if not jsonp or jsonp == '' then
        ngx.say(kidresult.errMsg("flow " .. tostring(flow) .. " is invalid", "422"))
    else
        ngx.header.content_type = "text/plain;charset=utf8"
        ngx.say(tostring(jsonp) .. "(" .. kidresult.errMsg("flow " .. tostring(flow) .. " is invalid", "422") .. ")")
    end
    return
end
if userId == nil or "" == userId then
    if not jsonp or jsonp == '' then
        ngx.say(kidresult.errMsg("userId " .. tostring(userId) .. " is invalid", "422"))
    else
        ngx.header.content_type = "text/plain;charset=utf8"
        ngx.say(tostring(jsonp) .. "(" .. kidresult.errMsg("userId " .. tostring(userId) .. " is invalid", "422") .. ")")
    end
    return
end
if not callfrom or callfrom == '' then
    if not jsonp or jsonp == '' then
        ngx.say(kidresult.errMsg("callfrom " .. tostring(callfrom) .. "  is invalid", "422"))
    else
        ngx.header.content_type = "text/plain;charset=utf8"
        ngx.say(tostring(jsonp) .. "(" .. kidresult.errMsg("callfrom " .. tostring(callfrom) .. " is invalid", "422") .. ")")
    end
    return
end


local flow_num = tonumber(flow)
local callfrom_num = tonumber(callfrom)
if not mathtool.isNumber(flow_num) then
    if not jsonp or jsonp == '' then
        ngx.say(kidresult.errMsg("flow " .. tostring(flow) .. " is invalid", "422"))
    else
        ngx.header.content_type = "text/plain;charset=utf8"
        ngx.say(tostring(jsonp) .. "(" .. kidresult.errMsg("flow " .. tostring(flow) .. " is invalid", "422") .. ")")
    end
    return
end

if not mathtool.isNumber(callfrom_num) then
    if not jsonp or jsonp == '' then
        ngx.say(kidresult.errMsg("callfrom " .. tostring(callfrom) .. "  is invalid", "422"))
    else
        ngx.header.content_type = "text/plain;charset=utf8"
        ngx.say(tostring(jsonp) .. "(" .. kidresult.errMsg("callfrom " .. tostring(callfrom) .. " is invalid", "422") .. ")")
    end
    return
end






params["flow"] = flow_num
params["callfrom"] = callfrom_num

local request_body = json.encode(params, { indent = true })
local httpc = http.new()
httpc:set_timeout(3000)
local url = "http://api.bs.pre.gomeplus.com/v2/rebate/shareChain/kid"
local res, err = httpc:request_uri(url, {
    method = "POST",
    body = request_body,
    headers = {
        ["Content-Type"] = "application/json"
    }
})


if not res then
    ngx.log(ngx.ERR, "server error", err)
    if not jsonp or jsonp == '' then
        ngx.say(kidresult.errMsg("server error", "500"))
    else
        ngx.header.content_type = "text/plain;charset=utf8"
        ngx.say(tostring(jsonp) .. "(" .. kidresult.errMsg("server error", "500") .. ")")
    end
    return
end


local status = res.status
if status ~= 200 then
    if not jsonp or jsonp == '' then
        ngx.say(kidresult.errMsg("server error", "500"))
    else
        ngx.header.content_type = "text/plain;charset=utf8"
        ngx.say(tostring(jsonp) .. "(" .. kidresult.errMsg("server error", "500") .. ")")
    end
    return
end



local result_json = json.decode(res.body)
if jsonp == nil or "" == jsonp then
    ngx.say(kidresult.sucMsg("", result_json["data"].userId, result_json["data"].kid))
    return
else
    ngx.header.content_type = "text/plain;charset=utf8"
    ngx.say(jsonp .. "(" .. kidresult.sucMsg("", result_json["data"].userId, result_json["data"].kid) .. ")")
end
