local Server = {}





function Server.trigger(event, message)
  if not event then error("no event passed", 2) end
  local msg =  {'', '[TRIGGER]', '['..string.upper(event)..']', message or "" }
  log(msg)
end

return Server