--
-- Created by IntelliJ IDEA.
-- User: yaojian
-- Date: 2016/12/10
-- Time: 23:35
-- To change this template use File | Settings | File Templates.
--

module(...,package.seeall)
local dkjson = require "dkjson"


function sucMsg(msg,userId,kid)
    local result = {}
    local data = {}
    result["message"] = msg
    data["__code"] = "200"
    data["userId"] = userId
    data["kid"] = kid
    result["data"] = data
    return dkjson.encode(result,{indent=true})
end


function errMsg(msg,code)
    local result = {}
    local data = {}
    result["message"] = msg
    data["__code"] = code
    data["userId"] = ""
    data["kid"] = ""
    result["data"] = data
    return dkjson.encode(result,{indent=true})
end






