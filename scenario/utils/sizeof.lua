local function sizeof(tbl)
  if not tbl then return 0 end
  local len = 0
  for k, v in pairs(tbl) do
    len = len + 1
  end
  return len
end


return sizeof