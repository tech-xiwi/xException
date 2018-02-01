--[==[
xiwi module for Lua 5.3
Version 1.0
You can contact the author by sending an e-mail to 'xiwi' at the
email 'xiwi92@hotmail.com'.
Copyright (C) 2017-2020 xiwi
Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:
The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
--]==]

local xexception = {version=1.0}

_callback = nil

function xexception.setCallback(callback)
    _callback = callback
end

_ORIGIN_LOG = false

function xexception.setOriginLog(origin)
    _ORIGIN_LOG = origin
end

--字符串分割函数
--传入字符串和分隔符，返回分割后的table
local function split(str, delimiter)
    if str==nil or str=='' or delimiter == nil then
        return nil
    end
    
    local result = {}
    for match in (str..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end

local function simpleLog(errmsg)
    local trace_log = split(errmsg,'\n')
    local cache = {"stack traceback:"}
    local hasFunc = 0
    local log = ""
    for i=1, #trace_log do
        if (string.match(trace_log[i],": in function '"))then
          if hasFunc == 0 then
            table.insert(cache, trace_log[i])
            hasFunc = hasFunc + 1
          end
        elseif (string.match(trace_log[i],": in upvalue")) then
          table.insert(cache, trace_log[i])
        elseif (string.match(trace_log[i],": in metamethod")) then
          table.insert(cache, trace_log[i])
        end
    end
    if cache[4] ~= nil and "[C]: in function" == string.sub(cache[4],2,17) then
      table.remove(cache)
    end
    if #cache == 1 then
        table.insert(cache, errmsg)
    end
    for i=1,#cache do
      log = log..cache[i]
      if i ~= #cache then
        log = log.."\n"
      end
    end
    return log
end

-- 打印错误信息
local function __TRACKBACK__(errmsg)
    local log = ""

    if _ORIGIN_LOG then
        log = errmsg
    else
        log = simpleLog(errmsg)
    end
    
    print("---------------------------------------- TRACKBACK START ----------------------------------------")
        print(log)
    print("---------------------------------------- TRACKBACK  END  ----------------------------------------")
    if type(_callback) == 'function'then
        _callback(log)
    end
end

function xexception.catchException(func, ... )  
    temp = { ... }  
    arg = select("1", temp)    --返回第一个参数和其之后的所有参数 
    xpcall(function() func(arg) end, function() 
    __TRACKBACK__(debug.traceback())
    end, arg)
end 

function xexception.catch(what)
   return what[1]
end

function xexception.try(what)
   status, result = pcall(what[1])
   if not status then
      what[2](result)
   end
   return result
end

function xexception.tryCatchError(func, ... )
    local temp = { ... }  
    local arg = select("1", temp)    --返回第一个参数和其之后的所有参数 
    xexception.try {
        function ()
            func(arg)
        end
       ,
       xexception.catch {
          function(error)
             __TRACKBACK__(error)
          end
       }
    }
end

return xexception