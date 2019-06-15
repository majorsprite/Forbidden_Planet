local Event                = { }
local event_handlers       = { }
local on_nth_tick_handlers = { }

--------------------------------------------------------
-- Callers
--------------------------------------------------------
local function call_event_handlers(event)
  if not event then return end
  local name = event.name
  if not name then return end

  local handlers = event_handlers[name]
  if not handlers then return end
  
  for _, handler in pairs(handlers) do
    handler(event)
  end
end

local function call_init_handlers(event)
  if event ~= nil then return end
  local handlers = event_handlers["on_init"]
  for _, handler in pairs(handlers) do
    handler(event)
  end
end

local function call_load_handlers(event)
  if event ~= nil then return end
  local handlers = event_handlers["on_load"]
  for _, handler in pairs(handlers) do
    handler(event)
  end
end

local function call_nth_tick_handlers(event)
  if not event then return end
  local handlers = on_nth_tick_handlers[event.nth_tick]
  for _, handler in pairs(handlers) do
    handler(event)
  end
end

--------------------------------------------------------
-- Events
--------------------------------------------------------
function Event.on_init(handler)
  if not handler then error ("No event handler passed", 2) end
  if not event_handlers["on_init"] then
    event_handlers["on_init"] = { handler }
    script.on_init(call_init_handlers)
  else
    table.insert(event_handlers["on_init"], handler)
  end
end

function Event.on_load(handler)
  if not handler then error ("No event handler passed", 2) end
  if not event_handlers["on_load"] then
    event_handlers["on_load"] = { handler }
    script.on_load(call_load_handlers)
  else
    table.insert(event_handlers["on_load"], handler)
  end
  
end

function Event.register(name, handler)
  local event = defines.events[string.format("on_%s",name)]
  if not event then
    error(string.format("unknown event. ( %s )", name), 2)
  end

  if not handler then 
    error("No event handler passed", 2)
  end
  
  if not event_handlers[event] then
    event_handlers[event] = { handler }
    script.on_event(event, call_event_handlers)
  else
    table.insert(event_handlers[event], handler)
  end
end

function Event.on_nth_tick(tick, handler)
  if not on_nth_tick_handlers[tick] then
    on_nth_tick_handlers[tick] = { handler }
    script.on_nth_tick(tick, call_nth_tick_handlers)
  else
    table.insert(on_nth_tick_handlers[tick], handler)
  end
end

function Event.create_custom_event(name)
  if defines.events[name] then
    error("Event already created", 2)
  end

  local id = script.generate_event_name()
  defines.events[name] = id
  return id
end

function Event.trigger(name, data)
  local id = defines.events[name]
  if not id then 
    error("Custom event name not found", 2)
  end
  script.raise_event(id, data)
end

return Event