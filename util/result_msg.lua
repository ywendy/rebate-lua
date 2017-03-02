


module(..., package.seeall)
local dkjson = require "dkjson"

function sucMsg(itemId,value)
    local obj = {}
    obj["message"]= ""
    local data = {}
    data["ID"] = itemId
    data["prospectiveRebateAmount"] = value
    obj["data"] = data
    return dkjson.encode(obj,{indent=true})
end

function errMsg(msg,code)
    local obj = {}
    obj["mssage"]= msg
    local data = {}
    setmetatable(data,  { __jsontype = 'object' })
    obj["data"] = data
    return dkjson.encode(obj)
end


