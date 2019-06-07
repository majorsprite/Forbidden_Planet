local function distance(from, to)
  local tmp = ( (to[1] - from[1])^2 + (to[2] - from[2])^2 )
  return math.sqrt(tmp)
end


return distance