ipip.net付费版IP库的lua解析, ip库信息请查看http://ipip.net

find.lua
----------------
输入一个ip，返回IP具体信息的json串。同时利用ngx.shared.dict做缓存，提高处理能力。返回结果中包含了是否为基站IP或者IDC IP的字段。


ipdatX.lua
----------------
每日高级版lua解析代码。需根据ip库存放位置，修改相关代码。

ipstation.lua
----------------
基站数据lua解析代码。需根据ip库存放位置，修改相关代码。

ipidc.lua
---------------
idc文本数据lua解析代码。需要ip库存放位置，修改相关代码。

Usage
---------------
请求方式为：curl '127.0.0.1/ip?ip=8.8.8.8'，nginx.conf相关配置如下：
```
http {
   lua_package_path '/path/to/?.lua;;';
   lua_shared_dict ip_cache 100m;
   ......
   server {
       ......
       location /ip {
           content_by_lua_file "/ptah/to/find.lua";
       }
   }
}
```
返回结果:
```
{"data":{"longitude":"","city":"","province":"GOOGLE","provider":"谷歌公司","continent":"*","company":"","country":"GOOGLE","tz2":"","cn_code":"","country_code":"*","tel_code":"","latitude":"","tz1":""},"code":0,"message":""}
```
