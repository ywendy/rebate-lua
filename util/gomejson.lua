--
-- Created by IntelliJ IDEA.
-- User: yaojian
-- Date: 2016/12/16
-- Time: 13:40
-- To change this template use File | Settings | File Templates.
--


local _M = {
    _VERSION = "0.10"
}

local mt = {__index = _M }


function _M.new(self, width, height)
    return setmetatable({ width=width, height=height }, mt)
end


return _M