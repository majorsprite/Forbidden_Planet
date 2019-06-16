local function generate_entities(entities, surface, check_collision)
  if not check_collision then check_collision = false end
  for index, entity in pairs(entities) do
    surface.create_entity(entity)
  end
end


return generate_entities
