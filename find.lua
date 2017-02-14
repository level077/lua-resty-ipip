local ipx = require "lua-resty-ipip.ipdatX"
local ipstation = require "lua-resty-ipip.ipstation"
local ipidc = require "lua-resty-ipip.ipidc"
local cjson = require "cjson"
local args = ngx.req.get_uri_args()
local ip = args["ip"]
if not ip then
	ngx.say("require ip")
	ngx.exit(400)
end

local ip_cache = ngx.shared.ip_cache
local value,err = ip_cache:get(ip)
if value then
        ngx.say(value)
        ngx.exit(200)
end
local info=(ipx.split(ipx.IpLocationX(ip),"\t"))
if not info then
	local t = {code = 404, message = "not found", data = ""}
	ngx.say(cjson.encode(t))
	return ngx.exit(200)
end
local t = {code = 0, message = "", data = {country = info[1], province = info[2], city = info[3], company = info[4], provider = info[5],longitude = info[6], latitude = info[7],tz1 = info[8],tz2 = info[9], cn_code = info[10],tel_code = info[11],country_code = info[12],continent = info[13]}}
local s = ipstation.IpLocationX(ip)
if ipstation.IpLocationX(ip) then
	t.data.station = 1
end
if ipidc.IpLocationX(ip) then
        t.data.idc = 1
end
local value = cjson.encode(t)
local succ,err,force = ip_cache:set(ip,value,43200)
if not succ then
        ngx.log(ERR,err)
end
ngx.say(value)
