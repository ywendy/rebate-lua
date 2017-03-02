--[[
-- description: get global unique id by compress uuid,the unique id length is 22
-- file:util/guid_compressor.lua
-- example: local guidcompressor = require "util.guid_compressor"
--          guidcompressor.get_new_globally_unique_id()
--          or guidcompressor.compress_globally_unique_id(uuid)
--
-- author : yj
-- date : 2016-12-14 13:24
-- version : 0.10
-- ]] --


local _M ={
    _VERSION = "0.10"
}




local _uuid = require "resty.uuid"
local _math = require "math"
local to_number = tonumber


local C_CONVERSION_TABLE = {
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D',
    'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y',
    'Z', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't',
    'u', 'v', 'w', 'x', 'y', 'z', '_', '$'
};


local function split(s, delim)
    if type(delim) ~= "string" or string.len(delim) <= 0 then
        return
    end
    local start = 1
    local t = {}
    while true do
        local pos = string.find(s, delim, start, true) -- plain find
        if not pos then
            break
        end

        table.insert(t, string.sub(s, start, pos - 1))
        start = pos + string.len(delim)
    end
    table.insert(t, string.sub(s, start))

    return t
end


local function get_guid_object(uuid_string)

    local paris = split(uuid_string, "-")
    local guid = {}
    guid.data1 = to_number(paris[1], 16)
    guid.data2 = to_number(paris[2], 16)
    guid.data3 = to_number(paris[3], 16)
    local tmp = paris[4]
    guid.data4 = {}
    guid.data4[1] = string.char(to_number(string.sub(tmp, 1, 2), 16))
    guid.data4[2] = string.char(to_number(string.sub(tmp, 3, 4), 16))
    tmp = paris[5]
    guid.data4[3] = string.char(to_number(string.sub(tmp, 1, 2), 16))
    guid.data4[4] = string.char(to_number(string.sub(tmp, 3, 4), 16))
    guid.data4[5] = string.char(to_number(string.sub(tmp, 5, 6), 16))
    guid.data4[6] = string.char(to_number(string.sub(tmp, 7, 8), 16))
    guid.data4[7] = string.char(to_number(string.sub(tmp, 9, 10), 16))
    guid.data4[8] = string.char(to_number(string.sub(tmp, 11, 12), 16))
    return guid
end


local function cv_to_64(number, code, len)
    local act
    local iDigit, nDigits
    local result = {}

    if (len > 5) then
        return false
    end
    act = number;
    nDigits = len;
    for iDigit = 1, nDigits, 1 do
        local mm = _math.floor(act % 64) + 1;
        if mm == 0 then
            mm = 1
        end
        result[nDigits - iDigit] = C_CONVERSION_TABLE[mm];
        act = _math.floor(act / 64);
    end
    result[len] = '\0';
    if act ~= 0 then
        return false
    end

    local i
    for i = 1, #result, 1 do
        local s = result[i]
        if not s or s == '' then
        else
            code[i] = result[i]
        end
    end

    return true
end


local function compress_guid_string(guid)
    local num = {}
    local str = {}
    for i = 1, 6 do
        str[i] = {}
        for j = 1, 5 do
            str[i][j] = ''
        end
    end
    local result = ""
    num[1] = _math.floor(to_number(guid.data1 / 16777216))
    num[2] = _math.floor(to_number(guid.data1 % 16777216))
    num[3] = _math.floor(guid.data2 * 256) + _math.floor(guid.data3 / 256)
    num[4] = _math.floor((guid.data3 % 256) * 65536 + to_number(string.byte(guid.data4[1])) * 256 + to_number(string.byte(guid.data4[2])))
    num[5] = _math.floor(to_number(string.byte(guid.data4[3])) * 65536 + to_number(string.byte(guid.data4[4])) * 256 + to_number(string.byte(guid.data4[5])))
    num[6] = _math.floor(to_number(string.byte(guid.data4[6])) * 65536 + to_number(string.byte(guid.data4[7])) * 256 + to_number(string.byte(guid.data4[8])))


    local n = 3;
    local i, j
    for i = 1, 6, 1 do

        if not cv_to_64(num[i], str[i], n) then
            return nil;
        end
        for j = 1, #str[i] + 1, 1 do
            if str[i][j] ~= '\0' then
                local s = str[i][j]
                if not s or s == '' then
                else
                    result = result .. s
                end
            end
        end
        n = 5
    end
    return result
end

--Generates a new GUID and returns a compressed string representation as used for newglobaluniqueid
function _M.get_new_globally_unique_id()
    local uid = _uuid.generate()
    return compress_guid_string(get_guid_object(uid))
end

function _M.compress_globally_unique_id(uuid)
    if not uuid or uuid == '' then
        return uuid
    end
    return compress_guid_string(uuid)
end

return _M