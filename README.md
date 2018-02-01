# xException
This is Pretty beautiful error log, You can listen the error and then to do special job!

# 使用样例

local x_error = require("xexception")

function listenError(...)

    print("need to restart ...")
    
    local temp = { ... }  
    
    local arg = select("1", temp) 
    
    --返回第一个参数和其之后的所有参数 
    
    for i=1,#arg do
    
            -- print(arg[i])
            
    end 
    
end


x_error.setCallback(listenError)

--测试 tryCatchError

x_error.tryCatchError(function(arg)

    for i=1,#arg do
    
            print("tryCatchError arg"..i, arg[i])
            
            -- error('error..')
            
            n = n/nil
    end  
    
    -- n = n/nil
    
end,10,11,12,"lua")

print()

-- 测试 catchException

x_error.catchException(function(arg)

    for i=1,#arg do
    
            print("catchException arg"..i, arg[i])
            
            error('error..')
            
            -- n = n/nil
            
    end  
    
    -- n = n/nil
    
end,100,101,102,"lua")    --输出为100,101,102,lua

print()


-- 测试使用x_error.try, x_error.catch 自定义逻辑

x_error.try {

        function ()
        
            error('hello error')
            
        end
        
       ,
       
       x_error.catch {
       
          function(error)
          
             print('custom error handler...',error)
             
          end
          
       }
       
}

# 输出日志

tryCatchError arg1      10
---------------------------------------- TRACKBACK START ----------------------------------------
stack traceback:
test.lua:18: attempt to perform arithmetic on a nil value (global 'n')
---------------------------------------- TRACKBACK  END  ----------------------------------------
need to restart ...

catchException arg1     100
---------------------------------------- TRACKBACK START ----------------------------------------
stack traceback:
        [C]: in function 'error'
        test.lua:27: in upvalue 'func'
---------------------------------------- TRACKBACK  END  ----------------------------------------
need to restart ...

custom error handler... test.lua:36: hello error
