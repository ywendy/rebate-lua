--
-- Created by IntelliJ IDEA.
-- User: yaojian
-- Date: 2016/12/16
-- Time: 13:39
-- To change this template use File | Settings | File Templates.
--

local _M =  {
    _VERSION = "0.10"
}

_M.__REBATE_HTTP_KID__ = ""

_M._REDIS_CONF = {
    ["host"] = "10.125.31.111",
    ["port"] = 6379,
    ["timeout"] = 3000,
    ["password"] = "gome123456"
}

_M._KID_CONF = {
    ["prefix"] = "kid:",
    ["expire"] = 3 * 24 * 60 * 60,
    ["fail_queue_key"] = "fail:kid"
}
_M._MYSQL_CONF_ = {
    ["host"] = "10.125.2.9",
    ["port"] = 3306,
    ["database"] = "rebate",
    ["user"] = "admin_develop",
    ["password"] = "admin6E85E1357Adev"
}
_M._REDIS_BLACK_IP_CONF_ = {
    ["black_prefix"] = "rebate:kid:black:prefix:",
    --expire ten minutes
    ["black_expire"] = 10*60
}

return _M

