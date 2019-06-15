local Global  = {}
local Event   = require "event"
global.data   = {}



function Global.register(data, callback)
  for k, v in pairs(data) do
    if not global.data[k] then
      global.data[k] = v
    else
      error(string.format("The key \'%s\' has already been registered in the global scope, please use a different key",k), 2)
    end
  end

  Event.on_load(function()  
    local tmp = {}
    for k, _ in pairs(data) do
      tmp[k] = global.data[k]
    end
    callback(tmp)  
  end)
end

return Global