local function distance(from, to)

  from.x = from.x or from[1]
  from.y = from.y or from[2]
  to.x = to.x or to[1]
  to.y = to.y or to[2]

  local tmp = ( (to.x - from.x)^2 + (to.y - from.y)^2 )
  return math.sqrt(tmp)
end


return distance