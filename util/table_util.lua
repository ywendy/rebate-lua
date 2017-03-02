

local M = {
    _VERSION = "0.10"
}

function isTableEmpty(t)
    if t == nil or _G.next(t) == nil then
        return true
    else
        return false
    end
end

return M


