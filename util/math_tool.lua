

module(...,package.seeall)

local math = require('math')


function isNumber(number)
	local t = type(number)
	if t == 'number' then
		return true
	else
		return false
	end
end

function conver2Number(number)
        if number == nil  then
                return 0
        end
	if isNumber(number) then
		return tonumber(number)
	else
		return 0
	end
end


function round(number,n)
	if not isNumber(number) then
		return toFixed(0,n)
	else
		if n<=0 then
			return number
		else
			local scale = math.pow(10,n)
			number = math.floor((number*scale)+0.5)/scale
			return toFixed(number,n)
		end
	end
end




function toFixed(num,n)
    local format = '%.'..n..'f'
    return string.format(format,num)
end











