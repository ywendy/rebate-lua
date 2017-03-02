-- http_util.lua
--author:yj
--date:2016-12-15 13:44
--using:http method judge and http header message

local M = {
    _VERSION = "0.10"
}



local __HTTP_METHOD__ = { 'GET', 'POST', 'TRACE', 'PUT', 'DELETE', 'OPTIONS', 'CONNECT' }
local __HTTP_CODE__ = { 200, 403, 500, 422 }
local __HTTP_CONTENT_TYPE__ = {
    ["text"] = "text/plain;charset=utf8",
    ["json"] = "application/json;charset=utf8"
}

M.__HTTP_METHOD__ = __HTTP_METHOD__
M.__HTTP_CODE__ = __HTTP_CODE__
M.__HTTP_CONTENT_TYPE__ = __HTTP_CONTENT_TYPE__


function M.isGet(request_method)
    return request_method == __HTTP_METHOD__[1]
end


function M.isPost(request_method)
    return request_method == __HTTP_METHOD__[2]
end

function M.isOptions(request_method)
    return request_method == __HTTP_METHOD__[6]
end

--param : true is empty,false is not empty
function M.isEmpty(param)
    return (not param or param == '')
end

--true
function M.isNotJsonp(jsonp)
    return (not jsonp or jsonp == '')
end


function M.isTableEmpty(t)
    if not t then
        return false
    end

    if next(t)  then
        return false
    end
    return true
end

return M
