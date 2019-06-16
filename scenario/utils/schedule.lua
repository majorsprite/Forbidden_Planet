local Event = require "utils.event"
local Global = require "utils.global"


local Schedule = {}
local scheduled_tasks = {}
local scheduled_timeout_tasks = {}

Global.register({
  scheduled_tasks = scheduled_tasks,
  scheduled_timeout_tasks = scheduled_timeout_tasks
}, function(global) 
  scheduled_tasks = global.scheduled_tasks
  scheduled_timeout_tasks = global.scheduled_timeout_tasks
end)


function Schedule.timeout(timeout, func, args)
  table.insert(scheduled_timeout_tasks, { timeout = game.tick + timeout, func = func, args = args } )
end


function Schedule.add(func, args)
  table.insert(scheduled_tasks, { func = func, args = args } )
end

function Schedule.next()
  if #scheduled_tasks >= 1 then
    local task = scheduled_tasks[1]
    table.remove(scheduled_tasks, 1, 1)
    local func = task.func
    local args = task.args
    pcall(func, unpack(args))
  end
end

local function tick()
  
  Schedule.next()

  for index, task in pairs(scheduled_timeout_tasks) do
    if game.tick >= task.timeout then
      pcall(task.func, unpack(task.args))
      table.remove(scheduled_timeout_tasks, index, 1)
    end
  end

end


Event.register("tick", tick)

return Schedule