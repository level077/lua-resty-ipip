local ipIDCFilePath = "/path/to/IDCList.txt"
local areaList = {}
local _M = {
        _VERSION = '0.0.1',
}

function split(szFullString, szSeparator)
        local nFindStartIndex = 1
        local nSplitIndex = 1
        local nSplitArray = {}
        while true do
                local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
                if not nFindLastIndex then
                        nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
                        break
                end
                nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
                nFindStartIndex = nFindLastIndex + string.len(szSeparator)
                nSplitIndex = nSplitIndex + 1
        end
        return nSplitArray
end

local function loadAreaListX()
	local file = io.open(ipIDCFilePath)
	for line in file:lines() 
	do
		local str = string.gsub(line,"%s+",",")
		local list = split(str,",")
		local ip1 = list[1]
		local ip2 = list[2]
		local o1,o2,o3,o4 = ip1:match("(%d+)%.(%d+)%.(%d+)%.(%d+)" )
		local n1,n2,n3,n4 = ip2:match("(%d+)%.(%d+)%.(%d+)%.(%d+)")
		local key = 2^24*o1 + 2^16*o2
		local t = {start = 2^8*o3 + o4, stop = 2^8*n3 + n4, msg = {country = list[3],province = list[4],city = list[5],company = list[6],provider = list[7]}}
		if not areaList[key] then
			areaList[key] = {}
			table.insert(areaList[key],t)
		else
			table.insert(areaList[key],t)
		end
	end
	file:close()
end

function _M.IpLocationX(ipstr)
	local ip1,ip2,ip3,ip4 = string.match(ipstr,"(%d+).(%d+).(%d+).(%d+)")
        local key = 2^24*ip1 + 2^16*ip2
        local range = 2^8*ip3 + ip4
        if not areaList[key] then
                return nil
        end
        for k,v in pairs(areaList[key])
        do
                if range >= v["start"]  and range <= v["stop"]  then
                        return v["msg"]
                end
        end
        return nil
end

loadAreaListX()

return _M
