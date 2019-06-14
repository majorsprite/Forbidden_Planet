local function count_occupied_inventory_slots(inventory)
  local contents = inventory.get_contents()
  local occupied_inventory_slots = 0
  for name, count in pairs(contents) do 
    local stack = game.item_prototypes[name].stack_size
    local slots = math.ceil(count / stack)
    occupied_inventory_slots = occupied_inventory_slots + slots
  end

  return occupied_inventory_slots
end


return count_occupied_inventory_slots