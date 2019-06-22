local Log = {}



function Log.info(str)
  local locale_string = {'', '[PRINT] ', nil}
  locale_string[3] = str
  log(locale_string)
end


return Log
