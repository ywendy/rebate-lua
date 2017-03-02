--
-- Created by IntelliJ IDEA.
-- User: yaojian
-- Date: 2016/12/12
-- Time: 22:02
-- To change this template use File | Settings | File Templates.
--


module(..., package.seeall)




local rebate_key_prefix = {
    "Rebate_Online_Plan_Key_1_1_", "Rebate_Online_Plan_Key_2_1_"
}


function getRebatePlatformShareKey(id)
    if not id then
        return rebate_key_prefix[1]
    end

    return rebate_key_prefix[1] .. id
end


function getRebatePlatformDistributeKey(id)
    if not id then
        return rebate_key_prefix[2]
    end
    return rebate_key_prefix[2] .. id
end

