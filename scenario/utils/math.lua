function math.map(val, in_min, in_max, out_min, out_max) 
  return  (val - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
end

function math.random_bias(items)
  local sum_of_biases = 0

  for _, item in pairs(items) do
    sum_of_biases = sum_of_biases + item.bias
  end

  local rng = math.random(sum_of_biases)


  for name, item in pairs(items) do
    if rng <= item.bias then
      return name
    end
    rng = rng - item.bias
  end

  error("Error! This should never get here", 2)
end