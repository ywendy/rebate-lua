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
    ["host"] = "ip address",
    ["port"] = 6379,
    ["timeout"] = 3000,
    ["password"] = "password"
}

_M._KID_CONF = {
    ["prefix"] = "kid:",
    ["expire"] = 3 * 24 * 60 * 60,
    ["fail_queue_key"] = "fail:kid"
}
_M._MYSQL_CONF_ = {
    ["host"] = "ip addresss",
    ["port"] = 3306,
    ["database"] = "database",
    ["user"] = "user",
    ["password"] = "pwd"
}
_M._REDIS_BLACK_IP_CONF_ = {
    ["black_prefix"] = "rebate:kid:black:prefix:",
    --expire ten minutes
    ["black_expire"] = 10*60
}

return _M

